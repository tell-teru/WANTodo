class CreateCounts < ActiveRecord::Migration[6.1]
  def change
    create_table :counts do |t|
      t.integer :number
      t.integer :user_id
      t.string :name
      t.string :img
    end
  end
end
