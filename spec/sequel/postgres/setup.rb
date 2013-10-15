require_relative '../../helper'
require_relative '../../support/postgres'

require 'sequel'
require 'logger'

db_config = {
  adapter:          'postgres',
  host:             'localhost',
  database:         PG::CONFIG[:database],
  max_connections:  PG::CONFIG[:pool],
  #logger:           Logger.new('log/db.log'),
  #logger:           Logger.new($stdout),
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

# Minitest threads
ENV['N'] ||= (DB.pool.max_size - 1).to_s

DB.disconnect
