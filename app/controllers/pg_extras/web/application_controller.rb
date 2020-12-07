module PgExtras
  module Web
    class ApplicationController < ActionController::Base
      layout "pg_extras/web/application"

      protect_from_forgery with: :exception

      helper_method :pg_stats_statements_enabled?

      private

      def load_queries
        @all_queries = {}

        RailsPGExtras::QUERIES.each do |query_name|
          @all_queries[query_name] = {
            disabled: query_disabled?(query_name),
            command:  query_name == :kill_all
          }
        end
      end

      def query_disabled?(query_name)
        query_name.in?([:calls, :outliers]) && !pg_stats_statements_enabled?
      end

      def pg_stats_statements_enabled?
        ActiveRecord::Base.connection.extensions.include?("pg_stat_statements")
      end
    end
  end
end
