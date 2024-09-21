class CreateCommissionMasters < ActiveRecord::Migration[7.2]
  def change
    create_table :commission_masters do |t|
      t.date :from_date, null: false
      t.date :to_date, null: false
      t.decimal :commission_fee, null: false

      t.timestamps
    end

    execute <<-SQL
        ALTER TABLE commission_masters
        ADD CONSTRAINT exclude_overlapping_commission_masters
        EXCLUDE USING gist (daterange(from_date, to_date, '[]') WITH &&);
      SQL
  end
end
