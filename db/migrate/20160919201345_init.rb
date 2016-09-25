class Init < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.datetime :time
      t.string :category
      t.integer :amount
      t.text :text
      t.integer :author_id
    end
  end
end
