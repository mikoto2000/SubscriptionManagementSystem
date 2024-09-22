class CreatePublishers < ActiveRecord::Migration[7.2]
  def change
    create_table :publishers do |t|
      t.string :name
      t.string :email_address

      t.timestamps
    end
  end
end
