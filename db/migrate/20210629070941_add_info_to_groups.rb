class AddInfoToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :company_name, :string
    add_column :groups, :website, :string
  end
end
