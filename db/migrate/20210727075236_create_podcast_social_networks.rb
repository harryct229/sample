class CreatePodcastSocialNetworks < ActiveRecord::Migration[6.1]
  def change
    create_table :podcast_social_networks, id: :uuid do |t|
      t.references :podcast, null: false, foreign_key: true, type: :uuid
      t.references :social_network, null: false, foreign_key: true, type: :uuid
      t.string :social_id
      t.string :url
      t.timestamps
    end
  end
end
