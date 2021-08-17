require 'open-uri'

class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @random_letters = []
    10.times { @random_letters << ('A'..'Z').to_a.sample }
  end

  def score
    @user_input = params['user_input'].upcase
    @grid = params['letters-array']
    @result = if validate_grid(@user_input, @grid) == false
                'The word can’t be built out of the original grid'
              elsif validate_dictionary(@user_input) == false
                'The word is valid according to the grid, but is not a valid English word'
              else
                'The word is valid according to the grid and is an English word'
              end
  end

  private

  def validate_grid(user_input, grid)
    user_letters = user_input.chars
    grid_letters = grid.chars
    user_letters.all? { |letter| user_letters.count(letter) <= grid_letters.count(letter)}
  end

  def validate_dictionary(user_input)
    url = "https://wagon-dictionary.herokuapp.com/#{user_input}"
    document = URI.open(url).read
    dictionary = JSON.parse(document)
    dictionary['found']
  end
end
