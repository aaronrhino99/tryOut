require 'terrapin'
require 'httparty'

class DownloadYoutubeAudioJob < ApplicationJob
  queue_as :default

  def perform(youtube_url, song_id, user_id)
    song = Song.find(song_id)
    user = User.find(user_id)
    
    video_id = extract_video_id(youtube_url)
    return if video_id.blank?

    song.update(youtube_id: video_id)

    begin
      # Get video metadata first
      video_info = get_video_info(youtube_url)
      update_song_metadata(song, video_info)

      # Download audio
      audio_tempfile = process_audio(youtube_url, song.title)
      attach_audio_file(song, audio_tempfile)

      # Process thumbnail
      if video_info[:thumbnail]
        process_thumbnail(song, video_info[:thumbnail], video_id)
      end

      song.update!(status: 'completed')
    rescue => e
      handle_error(song, e)
    end
  end

  private

  def get_video_info(url)
    command = Terrapin::CommandLine.new(
      "yt-dlp",
      "--print-json --skip-download :url",
      environment: { 'LC_ALL' => 'en_US.UTF-8' }
    )
    output = command.run(url: url)
    JSON.parse(output, symbolize_names: true)
  rescue JSON::ParserError
    raise "Failed to parse video information"
  end

  def update_song_metadata(song, info)
    song.update!(
      title: info[:title] || "Unknown Title",
      artist: info[:uploader] || "Unknown Artist",
      duration: info[:duration] || 0
    )
  end

  def process_audio(url, title)
    Tempfile.new(['audio', '.mp3'], binmode: true).tap do |tempfile|
      command = Terrapin::CommandLine.new(
        "yt-dlp",
        "-x --audio-format mp3 --audio-quality 0 -o :output :url",
        environment: { 'LC_ALL' => 'en_US.UTF-8' }
      )
      command.run(output: tempfile.path, url: url)
      tempfile.rewind
    end
  end

  def attach_audio_file(song, tempfile)
    song.audio_file.attach(
      io: tempfile,
      filename: "#{song.title.parameterize}.mp3",
      content_type: 'audio/mpeg'
    )
    raise "Audio attachment failed" unless song.audio_file.attached?
  ensure
    tempfile.close
    tempfile.unlink
  end

  def process_thumbnail(song, thumbnail_url, video_id)
    thumbnail_tempfile = Tempfile.new(['thumbnail', '.jpg'], binmode: true)
    
    response = HTTParty.get(thumbnail_url, stream_body: true, timeout: 30)
    raise "Thumbnail download failed" unless response.success?

    IO.binwrite(thumbnail_tempfile.path, response.body)
    thumbnail_tempfile.rewind

    song.album_art.attach(
      io: thumbnail_tempfile,
      filename: "#{video_id}_thumbnail.jpg",
      content_type: 'image/jpeg'
    )
    raise "Thumbnail attachment failed" unless song.album_art.attached?
  ensure
    thumbnail_tempfile.close
    thumbnail_tempfile.unlink if thumbnail_tempfile
  end

  def extract_video_id(url)
    regex = %r{
      (?:youtube\.com/(?:[^/]+/.+/|(?:v|e(?:mbed)?)/|.*[?&]v=)|
      youtu\.be/)([^"&?/\s]{11})
    }xi
    match = url.match(regex)
    match[1] if match
  end

  def handle_error(song, error)
    song.update!(
      status: 'failed',
      error_message: error.message.truncate(255)
    )
    Rails.logger.error "YouTube Audio Download Error: #{error.message}\n#{error.backtrace.join("\n")}"
  end
end