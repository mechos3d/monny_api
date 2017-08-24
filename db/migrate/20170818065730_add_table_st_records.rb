class AddTableStRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :st_records do |t|
      t.string :category
      t.integer :amount
      t.string :sign
      t.string :unit
      t.string :status
      t.text :text
      t.datetime :time
    end
  end
end
