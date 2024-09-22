class CreateSubscribers < ActiveRecord::Migration[7.2]
  def change
    create_table :subscribers do |t|
      t.string :name, null: false
      t.string :email_address, null: false

      t.timestamps
    end

    add_index :subscribers, :email_address, unique: true
  end
end
