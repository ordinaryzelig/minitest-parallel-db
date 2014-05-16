require_relative '../../helper'

require 'sequel'

db_config = {
  adapter:          'postgres',
  host:             'localhost',
  database:         DB_CONFIG[:postgres][:database],
  max_connections:  DB_CONFIG[:postgres][:pool],
}

DB = Sequel.postgres(db_config)

# Migration
DB.create_table! :postgres_sequel_models do
  primary_key :id
  String :name, null: false
end

# Model
Sequel::Model.plugin :validation_helpers
class PostgresSequelModel < Sequel::Model
  def validate
    super
    validates_presence [:name]
    validates_unique :name
  end
end
PSM = PostgresSequelModel

Minitest::ParallelDb.concurrency = DB.pool.max_size
