def redis
  @redis_connection ||= RedisConnection.new.db
end

def match_dao
  @match_dao ||= Match::Dao.new(db: redis)
end

def move_dao
  @move_dao ||= Move::Dao.new(db: redis)
end
