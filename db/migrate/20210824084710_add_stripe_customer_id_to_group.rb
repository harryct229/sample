class AddStripeCustomerIdToGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :stripe_customer_id, :string
  end
end
