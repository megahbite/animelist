# frozen_string_literal: true

class CalculateRedditScores
  def initialize(scoreable)
    @scoreable = scoreable
  end

  def calculate_score
    scores = useful_scores
    if scores.empty? || scores.count < Rails.configuration.app_config["scoring"]["minimum"]
      write_score(0)
      return
    end
    score = calculate_weighted_score(scores)
    write_score(score)
    score
  end

  def self.calculate_anime_ranks
    rank = 1
    # New scores will be the only ones without a rank so we can safely assume we won't rank the old scores.
    RedditScore.where(rank: nil, scoreable_type: "Anime").order(score: :desc).each do |score|
      score.rank = rank
      score.save
      score.scoreable.latest_rank = rank
      score.scoreable.save
      rank += 1
    end
  end

  def self.calculate_manga_ranks
    rank = 1
    # New scores will be the only ones without a rank so we can safely assume we won't rank the old scores.
    RedditScore.where(rank: nil, scoreable_type: "Manga").order(score: :desc).each do |score|
      score.rank = rank
      score.save
      score.scoreable.latest_rank = rank
      score.scoreable.save
      rank += 1
    end
  end

  private

  def useful_scores
    count = @scoreable.try(:episode_count) || @scoreable.try(:chapter_count)
    UserScore.where(scoreable: @scoreable).where.not(status: 6, score: 0) # Not on PTW list and has been scored
             .where("watched > ?", (count.to_f * 0.2).floor) # At least 20% watched
  end

  def calculate_weighted_score(scores)
    avg = scores.average(:score)
    count = scores.count().to_f
    weighted_average(count, avg)
  end

  def write_score(score)
    RedditScore.create(scoreable: @scoreable, score: score)
    @scoreable.latest_score = score
    @scoreable.save
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
