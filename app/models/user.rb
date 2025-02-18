class User < ApplicationRecord
  has_many :downloads
  has_many :songs, through: :downloads  # Establish many-to-many through downloads
  has_many :playlists

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
