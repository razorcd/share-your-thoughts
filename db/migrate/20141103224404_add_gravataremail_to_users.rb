class AddGravataremailToUsers < ActiveRecord::Migration
  def up
    add_column :users, :gravatar_email, :string
  end
end
