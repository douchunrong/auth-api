class CreateJoinTableAuthorizationScope < ActiveRecord::Migration[5.0]
  def change
    create_join_table :authorizations, :scopes do |t|
    end
  end
end
