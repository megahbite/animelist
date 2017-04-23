class AnimeDecorator < Draper::Decorator
  delegate :title, :image_url

  def rank
    object.latest_reddit_score.rank
  end

  def score
    object.latest_reddit_score.score.round(2)
  end

  def mal_score
    object.latest_mal_score.score
  end

  def mal_rank
    object.latest_mal_score.rank
  end

  def score_difference
    (object.latest_reddit_score.score - object.latest_mal_score.score).round(2)
  end
end