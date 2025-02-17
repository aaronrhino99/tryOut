# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :songs, dependent: :destroy
  has_many :playlists, dependent: :destroy

  # Add if you need admin functionality
  # attribute :admin, :boolean, default: false
end