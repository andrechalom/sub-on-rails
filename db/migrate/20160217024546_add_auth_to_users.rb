class AddAuthToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :user, index: true
    ### Maybe a explicit foreign key call...?
    add_foreign_key :users, :users, column: :user_id
  end
end
