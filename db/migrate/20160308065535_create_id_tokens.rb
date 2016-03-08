class CreateIdTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :id_tokens do |t|
      t.belongs_to :account, :client, null: false
      t.string :nonce, null: false
      t.datetime :expires_at, null: false
      t.timestamps null: false
    end
  end
end
