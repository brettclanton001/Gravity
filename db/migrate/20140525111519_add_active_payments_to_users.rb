class AddActivePaymentsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active_payments, :boolean, default: false
  end
end
