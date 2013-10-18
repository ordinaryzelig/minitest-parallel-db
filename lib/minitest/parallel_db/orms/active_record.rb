require 'pg'

module Minitest
  module ParallelDb
    module ActiveRecord

      def self.included(suite)
        suite.send(:include, ParallelDb)
      end

      def adapter_run
        model.transaction do
          yield
          raise ::ActiveRecord::Rollback
        end
        model.connection.close
      end

    end
  end
end
