require 'spec_helper'

require_relative '../../../lib/move/create'

describe Move::Create do
  subject(:creator) { described_class.new }

  describe '#call' do
    describe 'returned Move' do
      subject(:move) do
        creator.call({
          opponent_move: 'PAPER',
          game_id: 11
        })
      end

      its(:game_id)         { should == 11 }
      its(:opponent_move)   { should == 'PAPER' }
    end

    context 'when dao supplied' do
      let(:dao) { double(create: true) }

      subject(:creator) { described_class.new(dao: dao) }

      it 'saves to the DB' do
        expect(dao).to receive(:create).with({
          opponent_move: 'PAPER'
        })

        creator.call({
          opponent_move: 'PAPER'
        })
      end
    end

    context 'with no dao supplied' do
      it 'does not save to the DB' do
        expect { creator.call({}) }.to_not raise_error
      end
    end
  end
end