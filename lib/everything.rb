class Match
  attr_accessor :opponent_name, :points_to_win, :max_rounds, :dynamite_count
end

require 'singleton'

class MatchManager
  include Singleton

  def dao
    @dao || MatchRepo.new(DB.instance.db)
  end

  def create(opts)
    match = build(opts)

    binding.pry

    dao.create(
      opponent_name: match.opponent_name,
      points_to_win: match.points_to_win,
      max_rounds: match.max_rounds,
      dynamite_count: match.dynamite_count
    )

    match
  end

  def current
    id = dao.current_match_id

    load(id)
  end

  private

  def load(id)
    attrs = dao.get(id)
    build(attrs)
  end

  def build(attrs)
    match = Match.new

    attrs.each do |attr, val|
      match.send("#{attr}=", val) if match.respond_to?("#{attr}=")
    end

    match
  end
end

class MatchRepo < Struct.new(:db)
  def current_match_id
    db.get("game_id_counter")
  end

  def get(id)
    [:opponent_name, :points_to_win, :max_rounds, :dynamite_count].inject({}) do |match, attr|
      match[attr] = db.hget("game:#{id}", attr.to_s)

      match
    end
  end

  def create(attrs)
    id = new_match_id

    [:opponent_name, :points_to_win, :max_rounds, :dynamite_count].each do |attr|
      db.hset("game:#{id}", attr.to_s, attrs[attr])
    end

    id
  end

  private

  def new_match_id
    db.incr("game_id_counter")
  end
end

require 'redis'
require 'redis-namespace'
require 'uri'


class DB
  include Singleton

  def db
    @connection ||= begin
      if uri
        Redis::Namespace.new(:rock_paper, 
          host: uri.host,
          port: uri.port,
          password: uri.password
        )
      else
        Redis::Namespace.new(:rock_paper)
      end
    end
  end

  private

  def uri
    URI.parse(ENV["REDISCLOUD_URL"]) if ENV["REDISCLOUD_URL"]
  end
end