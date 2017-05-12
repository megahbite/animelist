class Manga < ApplicationRecord
  paginates_per 50

  has_many :reddit_scores, as: :scoreable
  has_many :mal_scores, as: :scoreable
  has_many :user_scores, as: :scoreable
end
