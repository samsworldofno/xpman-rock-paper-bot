require 'spec_helper'

require_relative '../../../lib/match/create'

describe Match::Create do
  subject(:creator) { described_class.new }

  describe '#call' do
    describe 'returned Match' do
      subject(:match) do
        creator.call({
          opponent_name: 'FATBOYSLIM',
          points_to_win: 2000,
          max_rounds: 1000,
          dynamite_count: 100
        })
      end

      its(:opponent_name)   { should == 'FATBOYSLIM' }
      its(:points_to_win)   { should == 2000 }
      its(:max_rounds)      { should == 1000 }
      its(:dynamite_count)  { should == 100 }
    end

    context 'when dao supplied' do
      let(:dao) { double(create: true) }

      subject(:creator) { described_class.new(dao: dao) }

      it 'saves to the DB' do
        expect(dao).to receive(:create).with({
            opponent_name: 'FATBOYSLIM',
            points_to_win: 2000,
            max_rounds: 1000,
            dynamite_count: 100
        })

        creator.call({
          opponent_name: 'FATBOYSLIM',
          points_to_win: 2000,
          max_rounds: 1000,
          dynamite_count: 100
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