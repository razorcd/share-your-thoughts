class Images < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :thought_id
      t.string :image_link, :limit => 128
    end
    add_index :images, :thought_id
  end
end
