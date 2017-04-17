class ProcessMalProfiles
  def self.get_user_scores(conn, mal_profile)
    profile_data = conn.get "/malappinfo.php", u: mal_profile, status: "all", type: "anime"
    doc = Nokogiri::XML(profile_data.body)
    doc.xpath("//anime")
  end

  def self.add_or_update_scores(user, scores)
    scores.each do |anime_node|
      mal_id = anime_node.at_xpath("series_animedb_id").content.to_i
      anime = Anime.where(mal_id: mal_id) || create_anime(mal_id, anime_node)
      score = UserScore.find_or_initialize(user: user, anime: anime)

      score.status = anime_node.at_xpath("my_status").content.to_i
      score.watched = anime_node.at_xpath("my_watched_episodes").content.to_i
      score.score = anime_node.at_xpath("my_score").content.to_i
      score.save
    end
  end

  private

  def self.create_anime(mal_id, anime_node)
    title = anime_node.at_xpath("series_title").content
    synonyms = anime_node.at_xpath("series_synonyms").content
    episode_count = anime_node.at_xpath("series_episodes").content.to_i
    image_url = anime_node.at_xpath("series_image").content

    Rails.logger.debug "Added #{title} anime to the database"
    Anime.create(mal_id: mal_id, title: title, synonyms: synonyms, episode_count: episode_count, image_url: image_url)
  end
end