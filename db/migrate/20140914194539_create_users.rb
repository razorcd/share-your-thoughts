class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name, :null => false, :limit => 128
      t.string :username, :null => false, :limit => 16
      t.string :password_digest#, :null => false, :limit => 128
      t.string :avatar, :limit => 64
      t.string :email, :null => false, :limit => 64
      t.boolean :email_confirmed, :default => false

      t.timestamps
    end

    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true
  end
end
