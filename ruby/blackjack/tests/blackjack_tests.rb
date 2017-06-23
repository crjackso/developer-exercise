require 'minitest/autorun'
require_relative '../blackjack'

class CardTest < Minitest::Test
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end

  def test_card_value_is_correct
    assert_equal @card.value, 10
  end

  def test_card_equality
    same_card = Card.new(:hearts, :ten, 10)
    different_card = Card.new(:hearts, :jack, 10)

    assert_equal(same_card, @card)
    assert(different_card != @card, 'A Jack of Hearts is not equal to a Ten of Hearts')
  end

  def test_to_s_includes_name_and_suite
    assert_equal 'two of diamonds', Card.new(:diamonds, :two, 2).to_s
  end

  def test_ace_returns_true
    card = Card.new(:clubs, :ace, [11, 1])

    assert_equal true, card.ace?
  end
end

class DeckTest < Minitest::Test
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(!@deck.playable_cards.include?(card))
  end

  def test_deck_should_not_have_duplicate_cards
    assert_equal @deck.playable_cards.size, @deck.playable_cards.uniq.size
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal 52, @deck.playable_cards.size
  end

  def test_shuffling_deck_changes_card_order
    original = @deck.playable_cards
    @deck.shuffle
    shuffled = @deck.playable_cards

    different = false

    original.each_with_index do |item, index|
      if item != shuffled[index]
        different = true
        break
      end
    end

    assert(different)
  end
end

class HandTest < Minitest::Test
  def setup
    @hand = Hand.new
  end

  def test_value_is_correct
    @hand.cards << Card.new(:hearts, :jack, 10)
    @hand.cards << Card.new(:clubs, :seven, 7)

    assert_equal 17, @hand.value
  end

  def test_value_treats_ace_as_1_when_hand_otherwise_busts
    @hand.cards << Card.new(:hearts, :ace, 11)
    @hand.cards << Card.new(:clubs, :ace, 11)

    assert_equal 12, @hand.value
  end

  def test_bust_is_true_when_over_21
    @hand.cards << Card.new(:hearts, :jack, 10)
    @hand.cards << Card.new(:clubs, :jack, 10)

    assert_equal false, @hand.bust?

    @hand.cards << Card.new(:spades, :jack, 10)

    assert_equal true, @hand.bust?
  end

  def test_blackjack_is_true_when_hand_equals_21_and_player_has_two_cards
    @hand.cards << Card.new(:hearts, :jack, 10)
    @hand.cards << Card.new(:clubs, :ace, 11)

    assert_equal true, @hand.blackjack?
  end

  def test_blackjack_is_false_when_hand_equals_21_but_has_more_than_two_cards
    @hand.cards << Card.new(:hearts, :jack, 10)
    @hand.cards << Card.new(:clubs, :seven, 7)
    @hand.cards << Card.new(:clubs, :four, 4)

    assert_equal false, @hand.blackjack?
  end
end