class AddTProviderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tprovider, :string
    add_column :users, :tuid, :string
  end
end
