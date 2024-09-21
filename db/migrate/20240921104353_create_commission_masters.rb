class CreateCommissionMasters < ActiveRecord::Migration[7.2]
  def change
    create_table :commission_masters do |t|
      t.date :from_date
      t.date :to_date
      t.decimal :commission_fee

      t.timestamps
    end
  end
end
