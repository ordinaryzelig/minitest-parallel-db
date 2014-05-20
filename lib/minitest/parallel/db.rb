require 'minitest'
require 'minitest/parallel/db/version'

module Minitest
  module Parallel
    module Db

      autoload :ActiveRecord, 'minitest/parallel/db/orms/active_record'
      autoload :Sequel,       'minitest/parallel/db/orms/sequel'

      def self.included(suite)
        suite.parallelize_me!
        suite.send :prepend, InstanceMethods
      end

      class << self

        attr_reader :concurrency

        def concurrency=(num)
          @concurrency = num
          if Minitest.const_defined?(:Parallel)
            Minitest.parallel_executor = Minitest::Parallel::Executor.new(num)
          else
            ENV['N'] = num
          end
        end

      end

      module InstanceMethods

        def run
          adapter_run do
            super
          end
          self
        end

      end

    end
  end
end
