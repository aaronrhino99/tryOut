class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @songs = current_user.songs.order(created_at: :desc).limit(10) || []
    @playlists = current_user.playlists.order(created_at: :desc).limit(5) || []
    @search_results = [] if params[:query].present?
  end
  
end
