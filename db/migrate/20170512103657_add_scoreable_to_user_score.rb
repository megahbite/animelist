# frozen_string_literal: true

class AddScoreableToUserScore < ActiveRecord::Migration[5.0]
  def change
    add_reference :user_scores, :scoreable, polymorphic: true, index: true
    ActiveRecord::Base.connection.execute("UPDATE user_scores
    SET scoreable_id = anime_id, scoreable_type = 'Anime'")
  end
end
