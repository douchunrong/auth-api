class CreateAuthorizations < ActiveRecord::Migration[5.0]
  def change
    create_table :authorizations do |t|
      t.belongs_to :account, :client, null: false
      t.string :code, null: false
      t.string :nonce, null: false
      t.string :redirect_uri, null: false
      t.datetime :expires_at, null: false
      t.timestamps null: false
    end
    add_index :authorizations, :code, unique: true
  end
end
