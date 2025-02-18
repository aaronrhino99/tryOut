class AddStatusToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :status, :integer
  end
end
