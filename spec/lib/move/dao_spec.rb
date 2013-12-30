require 'spec_helper'

require_relative '../../../lib/move/dao'

describe Move::Dao do
  let(:db)      { double }

  subject(:dao) { described_class.new(db: db) }

  describe '#create' do
    it 'saves the move against the passed game id' do
      expect(db).to receive(:lpush).with("matches:11:moves", 'PAPER')

      dao.create({
        match_id: 11,
        opponent_move: 'PAPER'
      })
    end
  end

  describe '#for_match' do
    it 'retrieves the moves for the given match' do
      expect(db).to receive(:lrange).with("matches:11:moves", 0, -1).and_return([])

      dao.for_match(match_id: 11)
    end

    it 'returns an array, most recent move first' do
      db.stub(lrange: %w{ROCK PAPER SCISSORS})

      dao.for_match(match_id: 11).should eq(['SCISSORS', 'PAPER', 'ROCK'])
    end
  end
end