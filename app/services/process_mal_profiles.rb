# frozen_string_literal: true

class ProcessMalProfiles
  def initialize(conn, user)
    @conn = conn
    @user = user
  end

  def anime_user_scores
    profile_data = @conn.get "/malappinfo.php", u: @user.mal_name, status: "all", type: "anime"
    doc = Nokogiri::XML(profile_data.body)
    doc.xpath("//anime")
  end

  def manga_user_scores
    profile_data = @conn.get "/malappinfo.php", u: @user.mal_name, status: "all", type: "manga"
    doc = Nokogiri::XML(profile_data.body)
    doc.xpath("//manga")
  end

  def add_or_update_anime_scores(scores)
    scores.each do |anime_node|
      mal_id = anime_node.at_xpath("series_animedb_id").content.to_i
      anime = Anime.find_by(mal_id: mal_id) || create_anime(mal_id, anime_node)
      score = UserScore.find_or_initialize_by(user: @user, scoreable: anime)

      score.status = anime_node.at_xpath("my_status").content.to_i
      score.watched = anime_node.at_xpath("my_watched_episodes").content.to_i
      score.score = anime_node.at_xpath("my_score").content.to_i
      score.save
    end
  end

  def add_or_update_manga_scores(scores)
    scores.each do |manga_node|
      mal_id = manga_node.at_xpath("series_mangadb_id").content.to_i
      manga = Manga.find_by(mal_id: mal_id) || create_manga(mal_id, manga_node)
      score = UserScore.find_or_initialize_by(user: @user, scoreable: manga)

      score.status = manga_node.at_xpath("my_status").content.to_i
      score.watched = manga_node.at_xpath("my_read_chapters").content.to_i
      score.score = manga_node.at_xpath("my_score").content.to_i
      score.save
    end
  end

  private

  def create_anime(mal_id, anime_node)
    title = anime_node.at_xpath("series_title").content
    synonyms = anime_node.at_xpath("series_synonyms").content
    episode_count = anime_node.at_xpath("series_episodes").content.to_i
    image_url = anime_node.at_xpath("series_image").content

    Rails.logger.debug "Added #{title} anime to the database"
    Anime.create(mal_id: mal_id, title: title, synonyms: synonyms, episode_count: episode_count, image_url: image_url)
  end

  def create_manga(mal_id, manga_node)
    title = manga_node.at_xpath("series_title").content
    synonyms = manga_node.at_xpath("series_synonyms").content
    chapter_count = manga_node.at_xpath("series_chapters").content.to_i
    image_url = manga_node.at_xpath("series_image").content

    Rails.logger.debug "Added #{title} manga to the database"
    Manga.create(mal_id: mal_id, title: title, synonyms: synonyms, chapter_count: chapter_count, image_url: image_url)
  end
end
