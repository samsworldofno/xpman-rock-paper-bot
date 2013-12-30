require 'spec_helper'

require_relative '../lib/server'

require 'rack/test'

describe Server do
  include Rack::Test::Methods

  def app
    Server
  end

  describe 'POST /start' do
    let(:match_creator) { double }

    before do
      Server.set :actors, {
        match_creator: match_creator
      }
    end

    it 'creates a new match' do
      expect(match_creator).to receive(:call)
      .with({
        opponent_name: 'FATBOYSLIM',
        points_to_win: 2000,
        max_rounds: 1000,
        dynamite_count: 100
      })

      post '/start', {
        'opponentName'  => 'FATBOYSLIM',
        'pointsToWin'   => 2000,
        'maxRounds'     => 1000,
        'dynamiteCount' => 100
      }
    end
  end

  describe 'POST /move' do
    let(:move_creator)  { double }

    let(:match_get_current) do
      double(call: double('match', id: 11))
    end

    before do
      Server.set :actors, {
        move_creator: move_creator,
        match_get_current: match_get_current
      }
    end

    it 'creates a new move' do
      expect(move_creator).to receive(:call)
      .with({
        match_id: 11,
        opponent_move: 'PAPER'
      })

      post '/move', {
        'lastOpponentMove' => 'PAPER'
      }
    end
  end

  describe 'GET /move' do
    let(:move_chooser) { double }
    let(:move_historian) { double(call: %w{ROCK PAPER SCISSORS}) }

    let(:match_get_current) do
      double(call: double('match', id: 11))
    end

    before do
      Server.set :actors, {
        match_get_current: match_get_current,
        move_chooser: move_chooser,
        move_historian: move_historian
      }
    end

    it 'retrieves the move history for the current game' do
      expect(move_historian).to receive(:call).with(
        match_id: 11
      )

      get '/move'
    end

    it 'generates a new move' do
      expect(move_chooser).to receive(:call).with(
        previous_moves: %w{ROCK PAPER SCISSORS}
      )

      get '/move'
    end
  end
end