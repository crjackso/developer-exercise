class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end

  def ==(other_object)
    return @suite == other_object.suite &&
      @name == other_object.name &&
      @value == other_object.value
  end

  def ace?
    name.to_s == 'ace'
  end

  def to_s
    "#{name} of #{suite}"
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end

    @playable_cards.shuffle!
  end
end

class Hand
  attr_accessor :cards
  BLACKJACK = 21

  def initialize
    @cards = []
  end

  def value
    value = 0
    @cards.each do |card|
      if card.ace?
        ace_value = 11
        ace_value = 1 if value + ace_value > BLACKJACK

        value += ace_value
      else
        value += card.value
      end
    end
    value
  end

  def bust?
    value > BLACKJACK
  end

  def blackjack?
    value == BLACKJACK && @cards.size == 2
  end
end