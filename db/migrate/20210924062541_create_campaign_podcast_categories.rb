class CreateCampaignPodcastCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :campaign_podcast_categories, id: :uuid do |t|
      t.references :podcast_category, null: false, foreign_key: true, type: :uuid
      t.references :campaign, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
