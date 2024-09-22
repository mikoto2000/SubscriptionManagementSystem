class CreatePlans < ActiveRecord::Migration[7.2]
  def change
    create_table :plans do |t|
      t.references :publisher, null: false, foreign_key: true
      t.string :name
      t.decimal :cost

      t.timestamps
    end
  end
end
