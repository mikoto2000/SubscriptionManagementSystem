class RemoveNameAndEmailFromPubsub < ActiveRecord::Migration[7.2]
  def change
    remove_columns :publishers, :name, :email_address, type: :string, null: false
    remove_columns :subscribers, :name, :email_address, type: :string, null: false
  end
end
