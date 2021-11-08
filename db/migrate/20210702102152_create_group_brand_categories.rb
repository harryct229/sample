class CreateGroupBrandCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :group_brand_categories, id: :uuid do |t|
      t.references :group, null: false, foreign_key: true, type: :uuid
      t.references :brand_category, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
