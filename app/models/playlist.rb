# app/models/playlist.rb
class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_songs, -> { order(position: :asc) }, dependent: :destroy
  has_many :songs, through: :playlist_songs

  validates :name, 
            presence: true,
            length: { maximum: 100 }
end