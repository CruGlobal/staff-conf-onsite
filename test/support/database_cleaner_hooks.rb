module Support
  module DatabaseCleanerHooks
    def self.included(base)
      #base.use_transactional_fixtures = false

      base.setup do
        DatabaseCleaner.clean_with(:truncation, { pre_count: true })
        DatabaseCleaner.strategy = :transaction
        DatabaseCleaner.start
      end
     

      base.after do
        DatabaseCleaner.clean
      end

      base.teardown { DatabaseCleaner.clean }
    end
  end
end
