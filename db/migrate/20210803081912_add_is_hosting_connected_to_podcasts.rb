class AddIsHostingConnectedToPodcasts < ActiveRecord::Migration[6.1]
  def change
    add_column :podcasts, :is_hosting_connected, :Boolean, default: false, null: false
    add_column :podcasts, :is_spotify_connected, :Boolean, default: false, null: false
  end
end
