require 'redis'
require 'redis/objects'
require 'redis/namespace'

host = ENV.fetch('REDIS_PORT_6379_TCP_ADDR')
Redis.current = Redis::Namespace.new("sco:#{Rails.env}", redis: Redis.new(host: host))
