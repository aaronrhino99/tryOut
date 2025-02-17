# app/models/playlist_song.rb
class PlaylistSong < ApplicationRecord
  belongs_to :playlist
  belongs_to :song

  validates :song_id, uniqueness: { scope: :playlist_id }
  validates :position, numericality: { 
    only_integer: true, 
    greater_than_or_equal_to: 0 
  }

  # For maintaining order in playlists
  acts_as_list scope: :playlist
end