require 'sinatra/base'

require_relative './redis_connection'

require_relative './match/create'
require_relative './match/get_current'
require_relative './match/dao'

require_relative './move/create'
require_relative './move/dao'

def redis_connection
  @redis_connection ||= RedisConnection.new.db
end

def match_dao
  @match_dao ||= Match::Dao.new(db: redis_connection)
end

def move_dao
  @move_dao ||= Move::Dao.new(db: redis_connection)
end

class Server < Sinatra::Base
  set :actors, {
    match_creator: Match::Create.new(dao: match_dao),
    match_get_current: Match::GetCurrent.new(dao: match_dao),
    move_creator: Move::Create.new(dao: move_dao)
  }

  def actors
    settings.actors
  end

  post '/start' do
    actors[:match_creator].call({
      opponent_name: params["opponentName"],
      points_to_win: params["pointsToWin"].to_i,
      max_rounds: params["maxRounds"].to_i,
      dynamite_count: params["dynamiteCount"].to_i
    })
  end

  post '/move' do
    current_game_id = actors[:match_get_current].call().id

    actors[:move_creator].call({
      opponent_move: params["opponentMove"],
      game_id: current_game_id
    })
  end
end