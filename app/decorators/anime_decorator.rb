class AnimeDecorator < Draper::Decorator
  delegate :title, :image_url, :to_param

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
    (object.latest_mal_rank - object.latest_rank)
  end

  def seen_by
    UserScore.where.not(status: 6).where(anime: object).count
  end

  def number_of_votes
    UserScore.where.not(status: 6, score: 0).where(anime: object).count
  end
end