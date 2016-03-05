class CreateJoinTableAccessTokenScope < ActiveRecord::Migration[5.0]
  def change
    create_join_table :access_tokens, :scopes do |t|
    end
  end
end
