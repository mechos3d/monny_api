class Init < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :string_field1
      t.integer :int_field1
      t.boolean :bool_field1
      t.datetime :date_field1
    end
  end
end
