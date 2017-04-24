# frozen_string_literal: true

class CalculateRedditScores
  def initialize(anime)
    @anime = anime
  end

  def calculate_anime_score
    scores = useful_scores
    if scores.empty? || scores.count < Rails.configuration.app_config["scoring"]["minimum"]
      write_score(0)
      return
    end
    score = calculate_score(scores)
    write_score(score)
    score
  end

  def self.calculate_anime_ranks
    rank = 1
    # New scores will be the only ones without a rank so we can safely assume we won't rank the old scores.
    RedditScore.where(rank: nil).order(score: :desc).each do |score|
      score.rank = rank
      score.save
      score.anime.latest_rank = rank
      score.anime.save
      rank += 1
    end
  end

  private

  def useful_scores
    UserScore.where(anime: @anime).where.not(status: 6, score: 0) # Not on PTW list and has been scored
             .where("watched > ?", (@anime.episode_count.to_f * 0.2).floor) # At least 20% watched
  end

  def calculate_score(scores)
    avg = scores.average(:score)
    count = scores.count().to_f
    weighted_average(count, avg)
  end

  def write_score(score)
    RedditScore.create(anime: @anime, score: score)
    @anime.latest_score = score
    @anime.save
  end

  def weighted_average(count, unweighted_avg)
    scoring_config = Rails.configuration.app_config["scoring"]
    # Minimum number of scores before a ranking is calculated
    minimum = scoring_config["minimum"]
    # Overall average of the whole MAL database (what we want to weight towards)
    mean = scoring_config["mean"]
    (count / (count + minimum)) * unweighted_avg + (minimum / (count + minimum)) * mean
  end
end
