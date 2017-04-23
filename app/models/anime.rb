class Anime < ApplicationRecord
  has_many :reddit_scores
  has_many :mal_scores
  has_many :user_scores

  
end
