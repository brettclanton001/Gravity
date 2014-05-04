class CreateUserCharges < ActiveRecord::Migration
  def change
    create_table :user_charges do |t|
      t.integer :user_id
      t.boolean :success, :default => false
      t.integer :amount
      t.date :period_start
      t.date :period_end

      t.timestamps
    end
    add_index :user_charges, :user_id, name: 'user_charges_by_user_id'
  end
end
