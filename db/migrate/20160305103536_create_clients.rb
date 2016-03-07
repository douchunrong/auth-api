class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.belongs_to :account, null: false
      t.string :redirect_uris, null: false
      t.string :identifier, null: false
      t.string :secret, null: false
      t.string :name, null: false
    end
    add_index :clients, :identifier, unique: true
  end
end
