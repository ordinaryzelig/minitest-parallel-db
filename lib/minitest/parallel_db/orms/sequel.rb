require 'pg'

module Minitest
  module ParallelDb
    module Sequel

      def self.included(suite)
        suite.send(:include, ParallelDb)
      end

      def adapter_run
        DB.transaction(rollback: :always) do
          yield
        end
      end

    end
  end
end
