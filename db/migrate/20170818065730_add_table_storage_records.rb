class AddTableStorageRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :storage_records do |t|
      t.string :category
      t.integer :amount
      t.string :sign
      t.string :unit
      t.string :status
      t.text :text

      t.datetime :updated_at
    end
  end
end
