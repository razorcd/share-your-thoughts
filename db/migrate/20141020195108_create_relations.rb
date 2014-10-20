class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations, {:id => false} do |t|
      t.integer :follower_id
      t.integer :followee_id
      t.timestamp
    end
    add_index :relations, :follower_id
    add_index :relations, :followee_id
  end
end
