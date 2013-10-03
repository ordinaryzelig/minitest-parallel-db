require_relative '../helper'
require 'pg'

class PostgresActiveRecordModel < ActiveRecord::Base
  validates :name, uniqueness: true
end
PARM = PostgresActiveRecordModel

db_config = {
  adapter:   'postgresql',
  database:  'minitest_parallel_db',
  pool:      10,
}

ENV['N'] = (db_config[:pool] - 1).to_s

begin
  PARM.establish_connection(db_config)
  PARM.connection
rescue
  ActiveRecord::Base.establish_connection(
    adapter:             db_config[:adapter],
    database:            'postgres',
    schema_search_path:  'public',
  )
  ActiveRecord::Base.connection.create_database(db_config[:database])
end

PARM.establish_connection(db_config)

if PARM.table_exists?
  PARM.delete_all
else
  PARM.connection.create_table PARM.table_name do |t|
    t.string :name, null: false
  end
end

describe 'ActiveRecord + Postgres' do

  extend Minitest::ParallelDb::ActiveRecord

  let(:model) { PARM }

  (PARM.connection_config[:pool] - 1).times do |idx|
    it idx do
      PARM.create! name: 'name'
      sleep 1
      PARM.count.must_equal 1
    end
  end

end
