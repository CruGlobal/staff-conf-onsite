require 'redis'
require 'redis/namespace'

host = ENV.fetch('REDIS_PORT_6379_TCP_ADDR')
port = ENV.fetch('REDIS_PORT_6379_TCP_PORT', 6379)

redis = Redis.new(host: host, port: port)
Redis.current = Redis::Namespace.new("cru-onsite:#{Rails.env}", redis: redis)
