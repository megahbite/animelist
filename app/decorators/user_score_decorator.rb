# frozen_string_literal: true

class UserScoreDecorator < Draper::Decorator
  delegate :watched

  def reddit_name
    object.user.reddit_name
  end

  def mal_name
    object.user.mal_name
  end

  def score
    object.score.positive? ? object.score : ""
  end

  def status
    case object.status
    when 1
      "Watching"
    when 2
      "Completed"
    when 3
      "On Hold"
    when 4
      "Dropped"
    when 6
      "Plan to Watch"
    end
  end
end
