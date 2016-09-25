class CreateSumTable < ActiveRecord::Migration[5.0]
  def change
    create_table :sums do |t|
      t.integer :amount
    end
  end
end
