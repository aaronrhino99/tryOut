class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.string :album
      t.integer :duration
      t.references :user, null: false, foreign_key: true
      t.string :youtube_id

      t.timestamps
    end
  end
end
