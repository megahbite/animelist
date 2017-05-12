# frozen_string_literal: true

class MangaDecorator < Draper::Decorator
  delegate :title, :image_url, :to_param, :mal_id, :cache_key, :synonyms, :chapter_count

  def self.collection_decorator_class
    PaginatedDecorator
  end

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

  def read_by
    UserScore.where.not(status: 6).where(scoreable: object).count
  end

  def number_of_votes
    UserScore.where.not(status: 6, score: 0).where(scoreable: object).count
  end
end
