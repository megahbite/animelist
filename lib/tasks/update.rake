# frozen_string_literal: true

namespace :update do
  desc "Pulls latest reddit posts on xxanime and extracts MAL profiles from flair of commentors"
  task users: :environment do
    user_flairs = ProcessRedditUsers.fetch_user_flairs(Rails.configuration.app_config["subreddit"])

    users = ProcessRedditUsers.extract_mal_profiles(user_flairs)
    users.each do |reddit_username, mal_profile|
      puts "Creating/updating reddit user #{reddit_username} with MAL profile #{mal_profile}"
      user = User.find_or_initialize_by(reddit_name: reddit_username)
      user.mal_name = mal_profile
      user.save
    end
  end

  desc "Pulls the anime/manga scores from the users' MAL profiles"
  task user_scores: :environment do
    conn = Faraday.new(url: "https://myanimelist.net")
    User.all.each do |user|
      service = ProcessMalProfiles.new(conn, user)
      anime_scores = service.anime_user_scores
      puts "Adding scores from #{user.reddit_name} for #{anime_scores.count} anime"
      service.add_or_update_anime_scores(anime_scores)
      manga_scores = service.manga_user_scores
      puts "Adding scores from #{user.reddit_name} for #{manga_scores.count} manga"
      service.add_or_update_manga_scores(manga_scores)
    end
  end

  desc "Calculates the score from users for the week"
  task calculate_scores: :environment do
    Anime.all.each do |anime|
      calculator = CalculateRedditScores.new(anime)
      score = calculator.calculate_score
      puts "Calculated the score for #{anime.title} as #{score}."
    end

    Manga.all.each do |manga|
      calculator = CalculateRedditScores.new(manga)
      score = calculator.calculate_score
      puts "Calculated the score for #{manga.title} as #{score}"
    end

    CalculateRedditScores.calculate_anime_ranks
    CalculateRedditScores.calculate_manga_ranks
  end

  desc "Pulls the community scores from MAL"
  task mal_scores: :environment do
    conn = Faraday.new(url: "https://myanimelist.net")
    ProcessMalScores.extract_anime_scores(conn)
    ProcessMalScores.extract_manga_scores(conn)
  end

  desc "Run all the tasks for updating the database"
  task all: %i[users user_scores calculate_scores mal_scores]
end
