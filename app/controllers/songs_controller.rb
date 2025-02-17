class SongsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_song, only: [:show, :update, :destroy]

  def index
    @songs = current_user.songs.all
    render json: @songs
  end

  def show
    render json: @song
  end

  def create
    @song = current_user.songs.new(song_params)
    if params[:youtube_url].present?
      # Queue background job for YouTube download
      DownloadYoutubeAudioJob.perform_later(params[:youtube_url], @song.id, current_user.id)
      render json: { message: "Download started", song: @song }, status: :accepted
    elsif @song.save
      render json: @song, status: :created
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  def update
    if @song.update(song_params)
      render json: @song
    else
      render json: @song.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @song.destroy
    head :no_content
  end

  def search_youtube
    query = params[:query]
    results = YoutubeService.search(query)
    render json: results
  end

  private

  def set_song
    @song = current_user.songs.find_by(id: params[:id])
    render json: { error: 'Song not found' }, status: :not_found unless @song
  end

  def song_params
    params.require(:song).permit(:title, :artist, :album, :duration, :youtube_id)
  end
end
