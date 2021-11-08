class AddPublishingDaysToPodcasts < ActiveRecord::Migration[6.1]
  def change
    add_column :podcasts, :publishing_days, :text, array: true, default: []
  end
end
