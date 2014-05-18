require 'pg'

module Minitest
  module Parallel::Db
    module Sequel

      def self.included(suite)
        suite.send(:include, Parallel::Db)
      end

      def adapter_run
        DB.transaction(rollback: :always) do
          yield
        end
      end

    end
  end
end
