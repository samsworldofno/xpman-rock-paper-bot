require 'spec_helper'

require_relative '../../../lib/move/chooser'

describe Move::Chooser::Decision do
  subject(:decision) { described_class.new(previous_moves: previous_moves) }

  describe '#call' do
    subject(:result) { decision.call }

    context 'first move' do
      let(:previous_moves) { [] }

      it { should == 'DYNAMITE' }
    end

    context 'previous move was dynamite' do
      let(:previous_moves) { %w{ DYNAMITE } }

      it { should == 'DYNAMITE' }
    end

    context 'there is a clear majority of previous moves and the coin flip is heads' do
      before do
        decision.stub(coin_flip: :heads)
      end

      let(:previous_moves) { %w{ PAPER SCISSORS PAPER } }

      it 'choses the move that beats that overly played move' do
        expect(result.should).to eq('SCISSORS')
      end

    end

    context 'there is no popular move' do
      let(:previous_moves) { %w{ PAPER SCISSORS ROCK } }

      context 'dice roll is 1 or 2' do
        before do
          decision.stub(dice_roll: rand(1) + 1)
        end

        it { should == 'DYNAMITE' }
      end

      context 'dice roll is 3' do
        before do
          decision.stub(dice_roll: 3)
        end 

        it "choses the opponent's last move" do
          result.should == 'ROCK'
        end
      end

      context 'dice roll is 4' do
        before do
          decision.stub(dice_roll: 4)
        end

        it 'choses a random move' do
          expect(%w{DYNAMITE SCISSORS PAPER ROCK}).to include(result)
        end
      end
    end
  end
end