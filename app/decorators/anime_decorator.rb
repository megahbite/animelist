class AnimeDecorator < Draper::Decorator
  delegate :title, :image_url

  def rank
    object.latest_rank
  end

  def score
    object.latest_score.round(2)
  end

  def mal_score
    object.latest_mal_score
  end

  def mal_rank
    object.latest_mal_rank
  end

  def score_difference
    (object.latest_score - object.latest_mal_score).round(2)
  end

  def rank_difference
    (object.latest_rank - object.latest_mal_rank)
  end
end