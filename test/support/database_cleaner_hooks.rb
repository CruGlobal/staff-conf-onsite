module Support
  module DatabaseCleanerHooks
    def self.included(base)
      #base.use_transactional_fixtures = false

      base.setup do
        # Custom truncate with CASCADE to satisfy PostgreSQL
        tables = ActiveRecord::Base.connection.tables - ['schema_migrations', 'ar_internal_metadata']
        ActiveRecord::Base.connection.execute("TRUNCATE #{tables.map { |t| %("#{t}") }.join(', ')} CASCADE")      
        DatabaseCleaner.strategy = :transaction
        DatabaseCleaner.start
      end
      # Clean up the database after each test
      base.teardown do
        DatabaseCleaner.clean
      end
    end
  end
end
