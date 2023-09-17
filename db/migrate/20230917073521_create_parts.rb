class CreateParts < ActiveRecord::Migration[6.1]
  def change
    create_table :parts do |t|
      t.integer :user_id
      t.integer :group_id
    end
  end
end
