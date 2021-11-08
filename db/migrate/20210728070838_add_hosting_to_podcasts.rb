class AddHostingToPodcasts < ActiveRecord::Migration[6.1]
  def change
    add_column :podcasts, :hosting, :string
  end
end
