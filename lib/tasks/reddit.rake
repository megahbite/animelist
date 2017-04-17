namespace :reddit do
  task pull_comments: :environment do
    user_flairs = ProcessRedditUsers.fetch_user_flairs("xxanime") 

    users = ProcessRedditUsers.extract_mal_profiles(user_flairs)
    users.each do |reddit_username, mal_profile|
      puts "Creating/updating reddit user #{reddit_username} with MAL profile #{mal_profile}"
      user = User.find_or_initialize_by(reddit_name: reddit_username)
      user.mal_name = mal_profile
      user.save
    end
  end
end
