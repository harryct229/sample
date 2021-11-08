class CreateBrandCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :brand_categories, id: :uuid do |t|
      t.string :name
      t.references :parent_category, index: true, foreign_key: {to_table: :brand_categories}, type: :uuid, null: true

      t.timestamps
    end
  end
end
