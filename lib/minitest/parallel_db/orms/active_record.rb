module Minitest
  module ParallelDb
    module ActiveRecord

      def self.extended(suite)
        suite.parallelize_me!
      end

      def it(*args, &block)
        super(*args) do
          model.transaction do
            block.call
            raise ::ActiveRecord::Rollback
          end
          model.connection.close
        end
      end

    end
  end
end
