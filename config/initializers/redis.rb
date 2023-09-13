require 'redis'
require 'redis/objects'

$redis = Redis.new(host: ENV['STORAGE_REDIS_HOST'],
                          port: ENV['STORAGE_REDIS_PORT'],
                          db: ENV['STORAGE_REDIS_DB_INDEX'])
