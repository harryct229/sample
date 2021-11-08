class CreateApiUsages < ActiveRecord::Migration[6.1]
  def change
    create_table :api_usages, id: :uuid do |t|
      t.references :subscription, null: false, foreign_key: true, type: :uuid
      t.integer :query_quota
      t.integer :email_quota
      t.integer :used_query_quota
      t.integer :used_email_quota

      t.timestamps
    end
  end
end
