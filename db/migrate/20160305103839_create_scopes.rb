class CreateScopes < ActiveRecord::Migration[5.0]
  def change
    create_table :scopes do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
    add_index :scopes, :name, unique: true
  end
end
