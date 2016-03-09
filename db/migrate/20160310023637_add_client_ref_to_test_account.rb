class AddClientRefToTestAccount < ActiveRecord::Migration[5.0]
  def change
    add_reference :accounts, :client, null: true, index: true
  end
end
