class AddIsTrialDoneToGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :is_trial_done, :boolean, default: false
  end
end
