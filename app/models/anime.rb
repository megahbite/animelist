class Anime < ApplicationRecord
  has_many :reddit_scores
  has_many :mal_scores
  has_many :user_scores

  def latest_reddit_score
    reddit_scores.order(created_at: :desc).limit(1)[0]
  end

  def latest_mal_score
    mal_scores.order(created_at: :desc).limit(1)[0]
  end
end
