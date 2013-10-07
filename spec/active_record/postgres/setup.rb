require_relative '../../helper'
require_relative '../../support/postgres'

# Model
class PostgresActiveRecordModel < ActiveRecord::Base
  validates :name, uniqueness: true
end
PARM = PostgresActiveRecordModel

# Create database.
begin
  PARM.establish_connection(PG::CONFIG)
  PARM.connection
rescue
  ActiveRecord::Base.establish_connection(
    adapter:             PG::CONFIG[:adapter],
    database:            'postgres',
    schema_search_path:  'public',
  )
  ActiveRecord::Base.connection.create_database(PG::CONFIG[:database])
end

PARM.establish_connection(PG::CONFIG)

# Cleanup/migration
if PARM.table_exists?
  PARM.delete_all
else
  PARM.connection.create_table PARM.table_name do |t|
    t.string :name, null: false
  end
end

# Minitest threads
ENV['N'] = (PARM.connection_config[:pool] - 1).to_s
