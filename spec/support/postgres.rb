# Database
require 'pg'

module PG

  CONFIG = {
    adapter:   'postgresql',
    database:  'minitest_parallel_db',
    pool:      10,
  }

end
