class CreateTiers < ActiveRecord::Migration[6.0]
  def change
    create_table :tiers, id: :uuid do |t|
      t.string :name
      t.integer :priority

      t.timestamps
    end
  end
end
