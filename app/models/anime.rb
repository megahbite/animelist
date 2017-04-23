class Anime < ApplicationRecord
  paginates_per 50

  has_many :reddit_scores
  has_many :mal_scores
  has_many :user_scores

  
end
