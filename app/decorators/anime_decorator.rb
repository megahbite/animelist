# frozen_string_literal: true

class AnimeDecorator < Draper::Decorator
  delegate :title, :image_url, :to_param, :mal_id, :cache_key

  def rank
    object.latest_rank
  end

  def score
    object.latest_score.positive? ? format("%.2f", object.latest_score.round(2)) : "-"
  end

  def mal_score
    object.latest_mal_score ? format("%.2f", object.latest_mal_score) : "-"
  end

  def mal_rank
    object.latest_mal_rank
  end

  def score_difference
    diff = (object.latest_score - (object.latest_mal_score || 0.0)).round(2)
    format("%+.2f", diff)
  end

  def rank_difference
    diff = ((object.latest_mal_rank || 0) - object.latest_rank)
    format("%+d", diff)
  end

  def seen_by
    UserScore.where.not(status: 6).where(anime: object).count
  end

  def number_of_votes
    UserScore.where.not(status: 6, score: 0).where(anime: object).count
  end
end
