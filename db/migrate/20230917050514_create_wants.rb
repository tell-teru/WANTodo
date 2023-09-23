class CreateWants < ActiveRecord::Migration[6.1]
  def change
    create_table :wants do |t|
      t.text :title
      t.text :place
      t.integer :user_id
      t.integer :genre_id
      t.integer :group_id
      t.boolean :done
    end
  end
end
