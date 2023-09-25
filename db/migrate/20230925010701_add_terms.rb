class AddTerms < ActiveRecord::Migration[6.1]
  def change
    add_column :wants, :start_date, :date, null: true, default: nil
    add_column :wants, :end_date, :date, null: true, default: nil
  end
end
