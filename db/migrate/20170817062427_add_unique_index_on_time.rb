class AddUniqueIndexOnTime < ActiveRecord::Migration[5.0]
  def change
    add_index :records, :time, unique: true
  end
end
