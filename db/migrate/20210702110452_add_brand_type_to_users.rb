class AddBrandTypeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :brand_type, foreign_key: true, type: :uuid, null: true
  end
end
