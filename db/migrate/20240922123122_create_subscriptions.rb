class CreateSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions do |t|
      t.references :publisher, null: false, foreign_key: true
      t.references :subscriber, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date
      t.references :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
