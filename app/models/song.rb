class Song < ApplicationRecord
  belongs_to :user
  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs
  has_one_attached :audio_file
  has_one_attached :album_art
  has_many :downloads

  validates :title, presence: true
  validates :youtube_id, 
            uniqueness: { scope: :user_id },
            format: { with: /\A[\w-]{11}\z/, message: "must be a valid YouTube ID" },
            allow_blank: true
  validates :status, presence: true
  
  enum status: { 
    waiting: 0, 
    processing: 1, 
    finished: 2, 
    failed: 3 
  }, _default: :waiting

  # Replace 'attached: true' with Active Storage validations
  validates :audio_file, presence: true, if: :completed?
  
  # Add Active Storage validation gem methods
  validates :audio_file,
          content_type: ['audio/mpeg'],  # Remove 'audio/mp3'
          size: { less_than: 50.megabytes }

  
  validates :album_art,
            content_type: ['image/jpeg', 'image/png'],
            size: { less_than: 5.megabytes },
            if: -> { album_art.attached? }
            
  private
  
  def completed?
    status == 'finished'
  end
end