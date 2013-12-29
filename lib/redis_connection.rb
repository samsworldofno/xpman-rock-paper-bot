require 'redis'
require 'redis-namespace'
require 'uri'

class RedisConnection
  def db
    @connection ||= begin
      redis = if uri
        Redis.new(
          host: uri.host,
          port: uri.port,
          password: uri.password
        )
      else
        Redis.new
      end

      Redis::Namespace.new(:rock_paper, redis: redis)
    end
  end

  private

  def uri
    URI.parse(ENV["REDISCLOUD_URL"]) if ENV["REDISCLOUD_URL"]
  end
end