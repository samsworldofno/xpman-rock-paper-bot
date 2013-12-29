require_relative './rock_paper'
require_relative './rock_paper/initializers'

require 'sinatra/base'

class Server < Sinatra::Base
  set :logging, true

  set :actors, {
    match_creator: Match::Create.new(dao: match_dao),
    match_get_current: Match::GetCurrent.new(dao: match_dao),
    move_creator: Move::Create.new(dao: move_dao)
  }

  def actors
    settings.actors
  end

  post '/start' do
    attrs = {
      opponent_name: params["opponentName"],
      points_to_win: params["pointsToWin"].to_i,
      max_rounds: params["maxRounds"].to_i,
      dynamite_count: params["dynamiteCount"].to_i
    }

    logger.info("POST /start: #{attrs.inspect}")

    actors[:match_creator].call(attrs)
  end

  post '/move' do
    current_game_id = actors[:match_get_current].call().id

    attrs = {
      opponent_move: params["lastOpponentMove"],
      game_id: current_game_id
    }

    logger.info("POST /move: #{attrs.inspect}")

    actors[:move_creator].call(attrs)
  end

  get '/move' do
    move = ['ROCK', 'PAPER', 'SCISSORS'].sample

    logger.info("GET /move: #{move}")

    move
  end
end