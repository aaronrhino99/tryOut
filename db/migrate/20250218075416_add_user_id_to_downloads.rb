class AddUserIdToDownloads < ActiveRecord::Migration[7.1]
  def change
    add_column :downloads, :user_id, :integer
  end
end
