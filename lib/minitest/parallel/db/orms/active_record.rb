require 'pg'

module Minitest
  module Parallel::Db
    module ActiveRecord

      def self.included(suite)
        suite.send(:include, Parallel::Db)
        suite.send(:include, TestInstanceMethods)
      end

      def adapter_run
        model.transaction do
          yield
          raise ::ActiveRecord::Rollback
        end
        model.connection.close
      end

      module TestInstanceMethods

        # If you want to be specific with a certain model,
        # define your own `model` method (or `let` statement).
        def model
          ::ActiveRecord::Base
        end

      end

    end
  end
end
