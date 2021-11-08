class CreateCampaigns < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')

    create_table :campaigns, id: :uuid do |t|
      t.references :created_by, null: false, foreign_key: {to_table: :users}, type: :uuid
      t.references :group, null: false, foreign_key: true, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :country, null: false, foreign_key: true, type: :uuid
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :budget, precision: 8, scale: 2
      t.integer :objective
      t.integer :creative_option
      t.string :name
      t.string :website
      t.integer :state
      t.hstore :budget_distributions, default: {}

      t.timestamps
    end
  end
end
