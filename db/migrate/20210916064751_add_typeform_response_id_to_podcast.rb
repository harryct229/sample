class AddTypeformResponseIdToPodcast < ActiveRecord::Migration[6.1]
  def change
    add_column :podcasts, :typeform_response_id, :string, null: true
  end
end
