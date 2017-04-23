class AddLatestMalRankAndLatestMalScoreToAnime < ActiveRecord::Migration[5.0]
  def change
    add_column :animes, :latest_mal_rank, :integer
    add_column :animes, :latest_mal_score, :float
  end
end
