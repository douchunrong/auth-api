class CreateConnectInternals < ActiveRecord::Migration[5.0]
  def change
    create_table :connect_internals do |t|
      t.belongs_to :account
      t.string :name, null: false
    end
    add_index :connect_internals, :name, unique: true
  end
end
