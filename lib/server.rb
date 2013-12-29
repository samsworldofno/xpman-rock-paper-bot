require_relative './rock_paper'
require_relative './rock_paper/initializers'

require 'sinatra/base'

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

  get '/move' do
    ['ROCK', 'PAPER', 'SCISSORS'].sample
  end
end