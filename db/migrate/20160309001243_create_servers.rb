class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.boolean :singleton_guard
      t.string :repo_url
      t.boolean :has_mail

      t.timestamps null: false
    end
  end
end
