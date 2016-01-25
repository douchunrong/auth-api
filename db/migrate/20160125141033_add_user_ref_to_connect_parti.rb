class AddUserRefToConnectParti < ActiveRecord::Migration
  def change
    add_column :connect_parti, :user_id, :integer
    add_index :connect_parti, :user_id
  end
end
