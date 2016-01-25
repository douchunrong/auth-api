class RenameConnectPartis < ActiveRecord::Migration
  def up
    rename_table :connect_partis, :connect_parti
  end

  def down
    rename_table :connect_parti, :connect_partis
  end
end
