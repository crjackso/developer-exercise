require 'minitest/autorun'
require_relative '../blackjack'
require_relative '../game'

class GameTest < Minitest::Test
  def setup
    @game = Game.new
  end

  def test_simulation
    @game.start
  end
end