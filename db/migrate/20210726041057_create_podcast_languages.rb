class CreatePodcastLanguages < ActiveRecord::Migration[6.1]
  def change
    create_table :podcast_languages, id: :uuid do |t|
      t.references :podcast, null: false, foreign_key: true, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
