require 'sinatra/base'

class RockPaper < Sinatra::Base
  post '/start' do
  end

  get '/move' do
    'ROCK'
  end

  post '/move' do
  end
end