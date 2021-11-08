class CreatePublishers < ActiveRecord::Migration[6.0]
  def change
    create_table :publishers, id: :uuid do |t|
      t.string :name
      t.string :website
      t.text :description

      t.timestamps
    end
  end
end
