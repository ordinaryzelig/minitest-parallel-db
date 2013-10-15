module Minitest
  module ParallelDb
    module Sequel

      def self.extended(suite)
        suite.parallelize_me!
      end

      def it(*args, &block)
        super(*args) do
          DB.transaction(rollback: :always) do
            block.call
          end
        end
      end

    end
  end
end
