class Game
  attr_accessor :player_hand, :dealer_hand, :dealer_hidden_card
  DEALER_HIT_THRESHOLD = 17
  MINIMUM_HAND_SIZE = 2

  PLAYER_NAME = 'Player'
  DEALER_NAME = 'Dealer'

  def initialize
    @player_hand = Hand.new
    @dealer_hand = Hand.new
    @dealer_visible_card = nil
  end

  def start
    @deck = Deck.new
    @deck.shuffle

    deal_initial_cards(@player_hand, PLAYER_NAME)

    check_hand_value(PLAYER_NAME, @player_hand)
    puts "** #{PLAYER_NAME} has a total of #{@player_hand.value}"
    puts

    deal_initial_cards(@dealer_hand, DEALER_NAME)

    @dealer_visible_card = @dealer_hand.cards.last

    check_hand_value(DEALER_NAME, @dealer_hand)
    puts "** #{DEALER_NAME} has a total of #{@dealer_hand.value}"
    puts

    execute_player_hit_strategy

    execute_dealer_hit_strategy

    if @dealer_hand.value > @player_hand.value
      puts "*** #{PLAYER_NAME} loses ***"
    elsif @dealer_hand.value == @player_hand.value
      puts '*** PUSH! ***'
    else
      puts "*** #{PLAYER_NAME} wins ***"
    end
  end

  private

  def execute_dealer_hit_strategy
    until @dealer_hand.value >= DEALER_HIT_THRESHOLD do
      card = @deck.deal_card
      log_hit DEALER_NAME, card
      @dealer_hand.cards << card
      puts "** #{DEALER_NAME} has a total of #{@dealer_hand.value}"

      check_hand_value(DEALER_NAME, @dealer_hand)
    end
  end

  def deal_initial_cards(hand, player_name)
    MINIMUM_HAND_SIZE.times do
      card = @deck.deal_card
      log_card player_name, card
      hand.cards << card
    end
  end

  def execute_player_hit_strategy
    bust_card = dealer_showing_bust_card?
    bust_card_threshold = 11

    if bust_card && @player_hand.value > bust_card_threshold
      puts "** #{PLAYER_NAME} stays at #{@player_hand.value}"
      return
    end

    until @player_hand.value >= 16
      card = @deck.deal_card
      log_hit PLAYER_NAME, card
      @player_hand.cards << card
      puts "** #{PLAYER_NAME} has a total of #{@player_hand.value}"
      check_hand_value PLAYER_NAME, @player_hand
    end

    puts "** #{PLAYER_NAME} stays at #{@player_hand.value}"
  end

  def dealer_showing_bust_card?
    return false if @dealer_visible_card.ace?
    @dealer_visible_card.value <= 6
  end

  def log_card(player_name, card)
    puts "#{player_name} was just dealt #{card}"
  end

  def log_hit(player_name, card)
    puts "#{player_name} just hit and was dealt #{card}"
  end

  def check_hand_value(player_name, hand)

    if hand.blackjack?
      puts "#{player_name} has blackjack and wins the hand"
      exit(0)
    elsif hand.bust?
      puts "#{player_name} busts and loses the hand"
      exit(0)
    end
  end
end