class AddSecretFieldToRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :secret, :boolean
  end
end
