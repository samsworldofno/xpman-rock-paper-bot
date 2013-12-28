require 'sinatra/base'
require 'pry'

require_relative './lib/everything'

module RockPaper
  class Server < Sinatra::Base
    get '/status' do
      "<xmp>#{MatchManager.instance.current.inspect}</xmp>"
    end

    post '/start' do
      match = MatchManager.instance.create(
        opponent_name: params["opponentName"],
        points_to_win: params["pointsToWin"],
        max_rounds: params["maxRounds"],
        dynamite_count: params["dynamiteCount"]
      )

      match.inspect
    end

    get '/move' do
      ['ROCK', 'PAPER', 'SCISSORS'].sample
    end

    post '/move' do
    end
  end
end