class CreateGlobalSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :global_settings, id: :uuid do |t|
      t.integer :singleton_guard
      t.string :name
      t.string :tracking_domain

      t.timestamps
    end

    add_index(:global_settings, :singleton_guard, :unique => true)
  end
end
