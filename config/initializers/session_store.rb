require "redis"

redis_conf = YAML.safe_load(ERB.new(File.read(Rails.root.join("config", "redis.yml"))).result, [Symbol], [], true)["session"]

Rails.application.config.session_store :cache_store, servers: redis_conf, expire_after: 8.hours
