require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    letters = ("a".."z").to_a
    @random_letters = []
    10.times { @random_letters << letters.sample.upcase }
  end

  def score
    @user_answer = params[:word].upcase
    @random_letters = params[:letters_string].chars
    # binding.pry
    if !english_word?(@user_answer)
      return @result = "#{@user_answer} is not an english word"
    elsif !in_the_grid?(@user_answer, @random_letters)
      return @result = "#{@user_answer} is not in the grid"
    else
      return @result = "Congratulation! #{@user_answer} is a valid English word!"
    end
  end

  private

  def in_the_grid?(word, grid)
    word.chars.each do |letter|
      if grid.index(letter.upcase)
        grid.delete_at(grid.index(letter.upcase))
      else
        return false
      end
    end
    return true
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    JSON.parse(word_serialized)["found"]
  end
end


# def run_game(attempt, grid, start_time, end_time)
#   # TODO: runs the game and return detailed hash of result
#   duration = end_time - start_time
#   if !english_word?(attempt)
#     return { time: duration, score: 0, message: "#{attempt} is not an english word" }
#   elsif !in_the_grid?(attempt, grid)
#     return { time: duration, score: 0, message: "#{attempt} is not in the grid" }
#   else
#     score = 1 / duration + attempt.size * 20
#     return { time: duration, score: score, message: "well done" }
#   end
# end




# def compute_score(attempt, time_taken)
#  time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
# end

# def run_game(attempt, grid, start_time, end_time)
#  result = { time: end_time - start_time }

#  score_and_message = score_and_message(attempt, grid, result[:time])
#  result[:score] = score_and_message.first
#  result[:message] = score_and_message.last

#  result
# end

# def score_and_message(attempt, grid, time)
#  if included?(attempt.upcase, grid)
#    if english_word?(attempt)
#      score = compute_score(attempt, time)
#      [score, "well done"]
#    else
#      [0, "not an english word"]
#    end
#  else
#    [0, "not in the grid"]
#  end
# end

