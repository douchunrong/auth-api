class AddIdentifierToAccounts < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :identifier, :string, null: false
  end
end
