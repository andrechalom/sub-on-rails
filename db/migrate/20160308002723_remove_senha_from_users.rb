class RemoveSenhaFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :senha, :string
  end
end
