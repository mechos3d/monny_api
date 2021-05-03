class AddUniqueIndexOnUidForDiaryRecords < ActiveRecord::Migration[5.0]
  def change
    add_index :'diary.records', :uid, unique: true
  end
end
