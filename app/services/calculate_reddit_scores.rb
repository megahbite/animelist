class CalculateRedditScores
  def self.calculate_anime_score(anime)
    scores = UserScore.where(anime: anime)
                      .where.not(status: 6) # Not on plan to watch list
                      .where.not(score: 0) # Has been scored at all
                      .where("watched > ?", (anime.episode_count.to_f * 0.2).floor) # At least 20% watched
    if scores.empty?
      set_score(anime, 0)
      return
    end
    sum = scores.sum(:score).to_f
    count = scores.count().to_f
    avg = sum / count
    score = weighted_average(sum, count, avg)
    set_score(anime, score)
    puts "Calculated the score for #{anime.title} as #{score}."
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

  def self.set_score(anime, score)
    RedditScore.create(anime: anime, score: score)
    anime.latest_score = score
    anime.save
  end

  def self.weighted_average(sum, count, unweighted_avg)
    minimum = Rails.configuration.app_config["scoring"]["minimum"] # Minimum number of scores before a ranking is calculated
    mean = Rails.configuration.app_config["scoring"]["mean"] # Overall average of the whole MAL database (what we want to weight towards)
    (count / (count + minimum)) * unweighted_avg + (minimum / (count + minimum)) * mean
  end
end