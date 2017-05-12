# frozen_string_literal: true

class AddScoreableToMalScore < ActiveRecord::Migration[5.0]
  def change
    add_reference :mal_scores, :scoreable, polymorphic: true, index: true
    ActiveRecord::Base.connection.execute("UPDATE mal_scores
    SET scoreable_id = anime_id, scoreable_type = 'Anime'")
  end
end
