require_relative '../../helper'
require_relative '../../support/postgres'

require 'active_record'

# Model
class PostgresActiveRecordModel < ActiveRecord::Base
  validates :name, uniqueness: true
end
PARM = PostgresActiveRecordModel

db_config = PG::CONFIG.merge(
  adapter: 'postgresql',
)

# Create database.
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

# Cleanup/migration
if PARM.table_exists?
  PARM.delete_all
else
  PARM.connection.create_table PARM.table_name do |t|
    t.string :name, null: false
  end
end

# Minitest threads
ENV['N'] = PARM.connection_config[:pool].to_s

PARM.connection.close
