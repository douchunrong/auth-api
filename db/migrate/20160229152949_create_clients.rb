require 'active_record'

class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
    end

    create_table :clients do |t|
      t.belongs_to :account
      t.string(:redirect_uris)
    end

    create_table :connect_parti do |t|
      t.belongs_to :account
      t.belongs_to :user
    end
  end
end
