class CreateSubscribers < ActiveRecord::Migration[7.2]
  def change
    create_table :subscribers do |t|
      t.string :name
      t.string :email_address

      t.timestamps
    end
  end
end
