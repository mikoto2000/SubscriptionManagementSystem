class CreatePlans < ActiveRecord::Migration[7.2]
  def change
    create_table :plans do |t|
      t.references :publisher, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :cost, null: false

      t.timestamps
    end

    add_index :plans, [:publisher_id, :name], unique: true
  end
end
