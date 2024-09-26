class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.string :type
      t.date :month_for_payment
      t.date :payment_date
      t.references :payment_status, null: false, foreign_key: true
      t.references :publisher, null: false, foreign_key: true
      t.references :subscriber, null: false, foreign_key: true

      t.timestamps
    end
  end
end
