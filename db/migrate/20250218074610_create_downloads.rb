class CreateDownloads < ActiveRecord::Migration[7.1]
  def change
    create_table :downloads do |t|

      t.timestamps
    end
  end
end
