class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.text :external_id, null: false, default: ""
      t.belongs_to :group, foreign_key: true, null: false, index: true, type: :uuid
      t.text :status, null: false
      t.boolean :cancel_at_period_end, null: false, default: false
      t.datetime :current_period_start, null: false
      t.datetime :current_period_end, null: false
      t.timestamps null: false
    end
  end
end
