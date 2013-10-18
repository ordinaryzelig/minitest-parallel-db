require "minitest/parallel_db/version"

module Minitest
  module ParallelDb

    autoload :ActiveRecord, 'minitest/parallel_db/orms/active_record'
    autoload :Sequel,       'minitest/parallel_db/orms/sequel'

    def self.included(suite)
      suite.parallelize_me!
    end

    def run
      adapter_run do
        super
      end
      self
    end

  end
end
