# frozen_string_literal: true

class AddLatestRankAndLatestScoreToAnime < ActiveRecord::Migration[5.0]
  def change
    add_column :animes, :latest_rank, :integer
    add_column :animes, :latest_score, :float
  end
end
