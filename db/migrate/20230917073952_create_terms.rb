class CreateTerms < ActiveRecord::Migration[6.1]
  def change
    create_table :terms do |t|
      t.integer :want_id
      t.date :start_date
      t.date :end_date
    end
  end
end
