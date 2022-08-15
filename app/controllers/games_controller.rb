require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def english_word
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    answer_serialized = URI.open(url).read
    answer = JSON.parse(answer_serialized)
    answer['found']
  end

  def letter_in_grid
    @word.chars.sort.all? { |letter| @letters.include?(letter) }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters]
    grid_letters = @letters.each_char { |letter| print letter, '' }

    if !letter_in_grid
      @score = "Sorry, but <b>#{@word.upcase}</b> can’t be built out of #{grid_letters}.".html_safe
    elsif !english_word
      @score = "Sorry but <b>#{@word.upcase}</b> does not seem to be a valid English word...".html_safe
    elsif letter_in_grid && !english_word
      @score = "Sorry but <b>#{@word.upcase}</b> does not seem to be a valid English word...".html_safe
    else
      @score = "<b>Congratulations !</b> #{@word.upcase} is a valid English word !".html_safe
    end
  end
end
