class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_playlist, only: [:show, :update, :destroy, :add_song, :remove_song]

   def new
    @playlist = Playlist.new
  end
  
  def index
    @playlists = current_user.playlists.all
    render json: @playlists
  end

  def show
    render json:  { playlist: @playlist, songs: @playlist.songs }
  end

  def create
    @playlist = current_user.playlists.build(playlist_params)
    if
      render json: @playlist, status: :created
    else
      render json: @playlist.errors, status: :unprocessable_entity
    end
  end

  def update
    if @playlist.update(playlist_params)
      render json: @playlist
    else
      render json: @playlist.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @playlist.destroy
    head :no_content
  end

  def add_song
    song = current_user.songs.find(params[:song_id])
    @playlist.songs << song unless @playlist.songs.include?(song)
    render json: { playlist: @playlist, songs: @playlist.songs }
  end

  def remove_song
    song = current_user.songs.find(params[:song_id])
    @playlist.songs.delete(song) 
    render json: { playlist: @playlist, songs: @playlist.songs}
  end

  private

  def set_playlist
    @playlist = current_user.playlists.find(params[:id])
  end

  def playlist_params
    params.require(:playlist).permit(:name, :description)
  end
end
