class AddDeviseConfirmableToPodcasts < ActiveRecord::Migration[6.1]
  def change
    add_column :podcasts, :confirmation_token, :string
    add_column :podcasts, :confirmed_at, :datetime
    add_column :podcasts, :confirmation_sent_at, :datetime
    add_column :podcasts, :unconfirmed_email, :string  
  end
end
