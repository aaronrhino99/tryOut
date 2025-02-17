class HomeController < ApplicationController
  before_action :authenticate_user!
  def Index
    @songs = currnent_user.songs.order(created_at: :desc).limit(10)
    @playllists = current_user.playlists.order(created_at: :desc).limit(5)

    # For Youtube search functionality
    @search_results = [] if params[:query]
  end
end
