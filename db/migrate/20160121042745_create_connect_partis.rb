class CreateConnectPartis < ActiveRecord::Migration
  def up
    create_table :connect_partis do |t|
      t.belongs_to :account
      t.timestamps
    end
  end

  def down
    drop_table :connect_partis
  end
end
