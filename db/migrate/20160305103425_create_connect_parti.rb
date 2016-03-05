class CreateConnectParti < ActiveRecord::Migration[5.0]
  def change
    create_table :connect_parti do |t|
      t.belongs_to :account
      t.belongs_to :user
    end
  end
end
