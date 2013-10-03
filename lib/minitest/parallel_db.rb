require "minitest/parallel_db/version"

module Minitest
  module ParallelDb

    autoload :ActiveRecord, 'minitest/parallel_db/orms/active_record'
    autoload :Sequel, 'minitest/parallel_db/orms/sequel'

  end
end
