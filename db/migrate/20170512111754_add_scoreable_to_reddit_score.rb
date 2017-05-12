# frozen_string_literal: true

class AddScoreableToRedditScore < ActiveRecord::Migration[5.0]
  def change
    add_reference :reddit_scores, :scoreable, polymorphic: true, index: true
    ActiveRecord::Base.connection.execute("UPDATE reddit_scores
    SET scoreable_id = anime_id, scoreable_type = 'Anime'")
  end
end
