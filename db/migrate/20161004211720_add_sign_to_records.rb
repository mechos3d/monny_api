class AddSignToRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :sign, :string, null: false
  end
end
