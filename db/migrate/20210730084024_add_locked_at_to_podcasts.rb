class AddLockedAtToPodcasts < ActiveRecord::Migration[6.1]
  def change
    add_column :podcasts, :locked_at, :datetime
  end
end
