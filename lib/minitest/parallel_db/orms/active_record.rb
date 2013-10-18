module Minitest
  module ParallelDb
    module ActiveRecord

      def self.included(suite)
        suite.parallelize_me!
      end

      def run
        model.transaction do
          super
          raise ::ActiveRecord::Rollback
        end
        model.connection.close
        self
      end

    end
  end
end
