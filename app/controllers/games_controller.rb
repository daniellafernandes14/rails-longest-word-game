require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def valid_letters?(attempt, grid)
    attempt.upcase.chars.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
    end
  end

  def english_word?(attempt)
    json_string = URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    word_hash = JSON.parse(json_string)
    word_hash['found']
  end

  def check_word(guess, grid)
    if valid_letters?(guess, grid)
      if english_word?(guess)
        "Congratulations! #{guess} is a valid English word"
      else
        "Sorry but #{guess} does not seem to be a valid English word..."
      end
    else
      "Sorry but #{guess} can't be built out of #{grid}"
    end
  end

  def score
    @guess = params[:word]
    @grid = params[:letters_array].split
    @valid = check_word(@guess, @grid)
  end
end
