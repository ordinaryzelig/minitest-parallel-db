require_relative '../../helper'

require 'active_record'

# Model
class PostgresActiveRecordModel < ActiveRecord::Base
  validates :name, uniqueness: true
end
PARM = PostgresActiveRecordModel

db_config = DB_CONFIG[:postgres].merge(
  adapter: 'postgresql',
)

# Create database.
begin
  ActiveRecord::Base.establish_connection(db_config)
  ActiveRecord::Base.connection
rescue
  ActiveRecord::Base.establish_connection(
    adapter:             db_config[:adapter],
    database:            'postgres',
    schema_search_path:  'public',
  )
  ActiveRecord::Base.connection.create_database(db_config[:database])
end

ActiveRecord::Base.establish_connection(db_config)

# Migration
ActiveRecord::Base.connection.tap do |conn|
  conn.drop_table PARM.table_name if PARM.table_exists?
  conn.create_table PARM.table_name do |t|
    t.string :name, null: false
  end
end

Minitest::ParallelDb.concurrency = ActiveRecord::Base.connection_config[:pool]
ActiveRecord::Base.connection.close
