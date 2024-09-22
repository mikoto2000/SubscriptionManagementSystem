class CreatePublishers < ActiveRecord::Migration[7.2]
  def change
    create_table :publishers do |t|
      t.string :name, null: false
      t.string :email_address, null: false

      t.timestamps
    end

    add_index :publishers, :email_address, unique: true
  end
end
