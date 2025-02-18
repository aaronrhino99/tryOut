class AddYoutubeFieldsToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :youtube_url, :string
    add_column :songs, :channel_title, :string
    add_column :songs, :thumbnail, :string
  end
end
