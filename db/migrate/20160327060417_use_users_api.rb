class UseUsersApi < ActiveRecord::Migration[5.0]
  def change
    remove_reference :connect_parti, :user
    add_column :connect_parti, :identifier, :string, null: false
    add_index :connect_parti, :identifier, unique: true
  end
end
