class RenameClientAccountIdToUserAccountId < ActiveRecord::Migration[5.0]
  def change
    rename_column :clients, :account_id, :user_account_id
  end
end
