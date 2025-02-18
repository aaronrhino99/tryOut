class AddSongIdToDownloads < ActiveRecord::Migration[7.1]
  def change
    add_column :downloads, :song_id, :integer
  end
end
