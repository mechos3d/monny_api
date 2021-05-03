class AddDiaryRecords < ActiveRecord::Migration[5.0]

  # NOTE: ATTENTION: currently this table is not shown in db/schema.rb file
  # (because of it's schema 'diary' I guess)
  def up
    enable_extension 'uuid-ossp'

    conn = ActiveRecord::Base.connection
    conn.execute('CREATE SCHEMA IF NOT EXISTS diary')

    create_table :'diary.records' do |t|
      t.uuid :uid, null: false, unique: true
      t.string :text, null: false
      t.datetime :creation_time, null: false
      t.date :date, null: false

      t.timestamps null: false
    end
  end

  def down
    drop_table :'diary.records'

    ActiveRecord::Base.connection.execute('DROP SCHEMA IF EXISTS diary')
    ActiveRecord::Base.connection.execute('DROP EXTENSION "uuid-ossp"')
  end
end
