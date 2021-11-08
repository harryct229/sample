class CreateBlacklistedDomains < ActiveRecord::Migration[6.1]
  def change
    create_table :blacklisted_domains, id: :uuid do |t|
      t.string :domain

      t.timestamps
    end

    add_index :blacklisted_domains, :domain, unique: true
  end
end
