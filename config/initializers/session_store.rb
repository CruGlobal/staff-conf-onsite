require Rails.root.join('config', 'initializers', 'redis')

Rails.application.config.session_store :redis_store, servers: {
  host: Redis.current.client.host,
  port: Redis.current.client.port,
  db: 2,
  namespace: 'cru-onsite:session:',
  expires_in: 2.days
}

require 'rack-cas/session_store/rails/active_record'
Rails.application.config.session_store ActionDispatch::Session::RackCasActiveRecordStore
