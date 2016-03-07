class CreateConnectParti < ActiveRecord::Migration[5.0]
  def change
    create_table :connect_parti do |t|
      t.belongs_to :account, null: false
      t.belongs_to :user, null: false
    end
  end
end
