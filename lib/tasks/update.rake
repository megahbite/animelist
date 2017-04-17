namespace :update do
  desc "Pulls latest reddit posts on xxanime and extracts MAL profiles from flair of commentors"
  task users: :environment do
    user_flairs = ProcessRedditUsers.fetch_user_flairs("xxanime") 

    users = ProcessRedditUsers.extract_mal_profiles(user_flairs)
    users.each do |reddit_username, mal_profile|
      puts "Creating/updating reddit user #{reddit_username} with MAL profile #{mal_profile}"
      user = User.find_or_initialize_by(reddit_name: reddit_username)
      user.mal_name = mal_profile
      user.save
    end
  end

  desc "Pulls the anime scores from the users' MAL profiles"
  task user_scores: :environment do
    conn = Faraday.new(url: "https://myanimelist.net")
    User.all.each do |user|
      anime_scores = ProcessMalProfiles.get_user_scores(conn, user.mal_name)
      puts "Adding scores from #{user.reddit_name} for #{anime_scores.count} anime"
      ProcessMalProfiles.add_or_update_scores(user, anime_scores)
    end
  end

  desc "Calculates the score from users for the week"
  task calculate_scores: :environment do
    Anime.all.each do |anime|
      scores = UserScore.where(anime: anime)
                        .where.not(status: 6)
                        .where.not(score: 0)
                        .where.not(watched: 0)
      next if scores.empty?
      sum = scores.sum(:score).to_f
      count = scores.count().to_f
      avg = scores.average(:score).to_f
      scoreChanger = 2.0
      mean = 6.55
      score = (count / (count + scoreChanger)) * avg + (scoreChanger / (count + scoreChanger)) * mean
      RedditScore.create(anime: anime, score: score)
      puts "Calculated the score for #{anime.title} as #{score}."
    end
  end
end
