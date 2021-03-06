# @todo Requirements
# Alter the game to get its words from the provided words.csv.
# The CSV has three lines. The first entry on each line is the difficulty and every other entry is a word for that difficulty.
# Example: e,cat,hat,bat,rat,sat,wat,nat,mat....
# The e is the difficulty (easy mode).
# Everything else is a word for the easy difficulty
# The updated program should read the csv and select a random word from the appropriate difficulty.
# No other gameplay changes are required.

require 'csv'

class WordGuess
  def initialize(debug = false)
    # are we in debug mode?
    @debug = true #debug

    # possible words, selected at random below (using .sample)
    # @words = {
    #   "e" => %w(dog cat bug hat cap lit kin fan fin fun tan ten tin ton),
    #   "m" => %w(plain claim brine crime alive bride skine drive slime stein jumpy),
    #   "h" => %w(
    #       machiavellian prestidigitation plenipotentiary quattuordecillion
    #       magnanimous unencumbered bioluminescent circumlocution
    #     )
    # }

    # players attempts allowed by difficulty
    @tries = {
      "e" => 10,
      "m" => 6,
      "h" => 4
    }

    # ask the user to set the game mode
    mode = set_mode

    if mode == 'm'
      @words_ary = CSV.read('words.csv')[0]  # for m #medium
    elsif mode == 'e'
      @words_ary = CSV.read('words.csv')[1] # for e #easy
    elsif mode == 'h'
      @words_ary = CSV.read('words.csv')[2] # for h #hard
    else
      puts "Error in set_mode"
    end

    @word = @words_ary[1...(@words_ary.length)].sample
    puts "The Easy array contains the word? True/False: #{CSV.read('words.csv')[1].include?(@word)}"
    puts "The Medium array contains the word? True/False: #{CSV.read('words.csv')[0].include?(@word)}"
    puts "The Hard array contains the word? True/False: #{CSV.read('words.csv')[2].include?(@word)}"
    #@word    = @words[mode].sample # chosen word; players try to guess this
    @guesses = @tries[mode] # how many tries the player gets
    @user_word = "•" * @word.length # a "blank word" for user output
    @guessed = [] # keep track of letters that have been guessed

    # debugging?
    if @debug
      puts "Your word is #{ @word }."
    end

    # user messages
    puts "You have #{ @guesses } guesses."
    puts "Guess the word: #{ @user_word }"

    # start the first turn
    play_turn
  end

  def play_turn
    # a turn begins by asking a player for their guess
    letter = ask_for_letter

    # update the word with the letter, maybe
    update_user_word!(letter)

    # decrement the available guesses
    # unless the letter matches and it's not already in the @guessed array
    lose_a_turn?(letter)

    # push the letter into the guessed array, if we need to
    add_to_guessed(letter)

    # debugging
    puts "Previous guesses: #{ @guessed.join(" ") }"
    puts "You guessed #{ letter }. The word is now #{ @user_word }."
    puts "You have #{ @guesses } guesses left."

    # determine if the player has won or lost
    if won?
      end_game(true)
    elsif lost?
      end_game(false)
    else # play another turn if we haven't won or lost
      play_turn
    end
  end

  private

  def add_to_guessed(letter)
    # push the letter to the array, then get rid of duplicates.
    @guessed.push(letter.upcase).uniq!
  end

  def end_game(won)
    if won
      puts "You wins the game! Yay! ^␣^"
    else
      puts "You did not wins the game. :( Next time you will, I bet. <3"
    end
    exit # game over!
  end

  def won?
    # we win when the user has guessed all the letters to the word
    @word == @user_word
  end

  def lost?
    # we lose when the user is out of guesses and has not guessed the word
    !won? && @guesses <= 0
  end

  def lose_a_turn?(letter)
    # if the guessed letter isn't part of the word and
    # the guessed letter isn't already in the list of guesses
    if !@word.chars.include?(letter) && !@guessed.include?(letter.upcase)
      @guesses -= 1
    end
  end

  #added change here, optional to myself
  def set_mode
    mode = ""
    until %w(e m h easy medium hard).include? mode
      print "\nThis can be (e)asy, (m)edium or really (h)ard. The choice is yours: "
      mode = gets.chomp[0].downcase
    end

    mode
  end

  def update_user_word!(letter)
    @word.chars.each_index do |index|
      @user_word[index] = letter if @word[index] == letter
    end
  end

  def ask_for_letter
    letter = ""
    until ('a'..'z').include? letter
      print "\nPlease guess a letter! (a..z): "
      letter = gets.chomp.downcase
    end

    letter
  end
end

WordGuess.new
