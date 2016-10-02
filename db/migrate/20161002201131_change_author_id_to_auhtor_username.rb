class ChangeAuthorIdToAuhtorUsername < ActiveRecord::Migration[5.0]
  def change
    remove_column :records, :author_id, :integer
    add_column :records, :author, :string
  end
end
