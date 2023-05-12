module Support
  module DatabaseCleanerHooks
    def self.included(base)
      #base.use_transactional_fixtures = false

      base.setup do
        DatabaseCleaner.strategy = :truncation, { pre_count: true }
        DatabaseCleaner.start
      end

      base.teardown { DatabaseCleaner.clean }
    end
  end
end
