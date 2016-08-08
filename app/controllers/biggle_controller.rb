class BiggleController < ApplicationController
  def game
		@grid = generate_grid(15)
		@start_time = Time.now
  end

  def score
		@end_time = Time.now
    @the_start_time = Time.parse(params[:start_time])
		@append = params[:reponse]
		@the_grid = params[:grid].chars
    @result = run_game(@append, @the_grid, @the_start_time, @end_time)
  end
end

private

def generate_grid(grid_size)
  Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
end


def included?(guess, grid)
  the_grid = grid.clone
  guess.chars.each do |letter|
    the_grid.delete_at(the_grid.index(letter)) if the_grid.include?(letter)
  end
  grid.size == guess.size + the_grid.size
end

def compute_score(attempt, time_taken)
  (time_taken > 60.0) ? 0 : attempt.size * (1.0 - time_taken / 60.0)
end

def run_game(attempt, grid, start_time, end_time)
  result = { time: end_time - start_time }

  result[:translation] = get_translation(attempt)
  result[:score], result[:message] = score_and_message(
    attempt, result[:translation], grid, result[:time])

  result
end

def score_and_message(attempt, translation, grid, time)
  if translation
    if included?(attempt.upcase, grid)
      score = compute_score(attempt, time)
      [score, "well done"]
    else
      [0, "not in the grid"]
    end
  else
    [0, "not an english word"]
  end
end


def get_translation(word)
  response = open("http://api.wordreference.com/0.8/80143/json/enfr/#{word.downcase}")
  json = JSON.parse(response.read.to_s)
  json['term0']['PrincipalTranslations']['0']['FirstTranslation']['term'] unless json["Error"]
end

# require_relative "longest_word"

# puts "******** Welcome to the longest word-game !********"
# puts "Here is your grid :"
# grid = generate_grid(9)
# puts grid.join(" ")
# puts "*****************************************************"
#
# puts "What's your best shot ?"
# start_time = Time.now
# attempt = gets.chomp
# end_time = Time.now
#
# puts "******** Now your result ********"
#
# result = run_game(attempt, grid, start_time, end_time)
#
# puts "Your word: #{attempt}"
# puts "Time Taken to answer: #{result[:time]}"
# puts "Translation: #{result[:translation]}"
# puts "Your score: #{result[:score]}"
# puts "Message: #{result[:message]}"
#
# puts "*****************************************************"
