class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.integer :likes_count, :default => 0
      t.integer :owner_id
      t.text :caption
      t.string :image
      t.integer :comments_count, :default => 0

      t.timestamps
    end
  end
end
