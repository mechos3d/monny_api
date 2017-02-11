class AddDayColumnToRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :date, :datetime
  end
end
