require "minitest/parallel_db/version"

module Minitest
  module ParallelDb

    autoload :ActiveRecord, 'minitest/parallel_db/orms/active_record'
    autoload :Sequel,       'minitest/parallel_db/orms/sequel'

    def self.included(suite)
      suite.parallelize_me!
    end

    def self.concurrency=(num)
      if Minitest.const_defined?(:Parallel)
        Minitest.parallel_executor = Minitest::Parallel::Executor.new(num)
      else
        ENV['N'] = num
      end
    end

    def run
      adapter_run do
        super
      end
      self
    end

  end
end
