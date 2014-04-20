class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit, :integer, :default => 0
    add_column :users, :discount_percent, :integer, :default => 0
    add_column :users, :active, :boolean, :default => true
    add_column :users, :max_charge, :integer, :default => 5
    add_column :users, :stripe_customer_token, :string
    add_column :users, :service_subscribed, :boolean, :default => true
    add_column :users, :promotion_subscribed, :boolean, :default => true
  end
end
