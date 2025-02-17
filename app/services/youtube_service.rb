require 'google/apis/youtube_v3'

class YoutubeService
  def self.search(query, max_results = 10)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = Rails.application.credentials.youtube[:api_key]

    search_response = service.list_searches('snippet', q: query, max_results: max_results, type: 'video')
    search_response.items.map do |search_result|
      {
        id: search_result.id.video_id,
        title: search_result.snippet.title,
        thumbnail: search_result.snippet.thumbnails.default.url,
        channel_title: search_result.snippet.channel_title,
        published_at: search_result.snippet.published_at
      }
    end
  rescue Google::Apis::Error => e
    Rails.logger.error "YouTube API error: #{e.message}"
    []
  end
end
