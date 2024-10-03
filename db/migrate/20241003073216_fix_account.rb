class FixAccount < ActiveRecord::Migration[7.2]
  def change
    remove_column :payments, :type, :string
    remove_column :payments, :month_for_payment, :date

    add_column :payments, :year, :integer, null: false
    add_column :payments, :month, :integer, null: false

    add_reference :payments, :account, foreign_key: true
    add_index :payments, [:year, :month, :account_id], unique: true
  end
end
