# app/models/song.rb
class Song < ApplicationRecord
  belongs_to :user
  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs

  has_one_attached :audio_file
  has_one_attached :album_art

  validates :title, presence: true
  validates :youtube_id, 
            uniqueness: { scope: :user_id },
            format: { with: /\A[\w-]{11}\z/, message: "must be a valid YouTube ID" },
            allow_blank: true
  validates :status, presence: true

  enum status: { 
    pending: 0, 
    processing: 1, 
    completed: 2, 
    failed: 3 
  }, default: :pending

  # Add these validations if you want to ensure attachments
  validates :audio_file, attached: true, if: :completed?
  validates :audio_file, content_type: ['audio/mpeg', 'audio/mp3'],
                        size: { less_than: 50.megabytes }

  validates :album_art, content_type: ['image/jpeg', 'image/png'],
                        size: { less_than: 5.megabytes },
                        if: -> { album_art.attached? }
end