class CreatePodcastCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :podcast_categories, id: :uuid do |t|
      t.string :name
      t.references :parent_category, index: true, foreign_key: {to_table: :podcast_categories}, type: :uuid, null: true

      t.timestamps
    end
  end
end
