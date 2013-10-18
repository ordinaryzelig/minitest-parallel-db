require 'pg'

module Minitest
  module ParallelDb
    module Sequel

      def self.included(suite)
        suite.parallelize_me!
      end

      def run
        DB.transaction(rollback: :always) do
          super
        end
        self
      end

    end
  end
end
