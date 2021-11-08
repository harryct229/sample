class CreateUserSocialNetworks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_social_networks, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :social_network, null: false, foreign_key: true, type: :uuid
      t.string :profile_url

      t.timestamps
    end
  end
end
