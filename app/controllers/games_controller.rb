require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (('A'...'Z').to_a).sample(10)
    @start_time = Time.now
  end

  def score
    @guess = params[:word]
    @start_time = params[:start_time].to_time
    @end_time = Time.now
    @grid = params[:grid]
    @time_taken = @end_time - @start_time

    if @guess == ""
      @answer = "choose a word"
    elsif !include?(@guess, @grid)
      @answer = "Sorry '#{@guess}'' not to be build out of #{@letters}"
    elsif english_word?(@guess)
      @answer = "Congratulations!!"
    else
      @answer = "Sorry '#{@guess}'' does not same to be a valid English word"
    end
   @time_taken > 60 ? @score = 0 : @score = (@guess.length * ((1 - @time_taken) / 60))
  end

  private

  def english_word?(word)
    if word == ""
      return "put word"
    else
      url = open("https://wagon-dictionary.herokuapp.com/#{word}")
      json = JSON.parse(url.read)
      return json['found']
    end
  end

  def include?(guess, letters)
    guess.upcase.chars.all? { |letter| guess.count(letter) <= letters.count(letter) }
  end
end
