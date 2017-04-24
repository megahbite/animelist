# frozen_string_literal: true

class FrontPageAnimesDecorator < Draper::CollectionDecorator
  delegate :current_page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?

  def number_of_users
    User.count
  end

  def current_subreddit
    Rails.configuration.app_config["subreddit"]
  end

  def reddit_average
    (RedditScore.where.not(score: 0).average(:score) || 0.0).round(2)
  end

  def mal_average
    (MalScore.average(:score) || 0.0).round(2)
  end
end
