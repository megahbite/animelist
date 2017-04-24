# frozen_string_literal: true

class ProcessMalScores
  def self.extract_scores(conn)
    i = 0
    loop do
      mal_page = conn.get "/topanime.php", limit: i
      doc = Nokogiri::HTML(mal_page.body)

      rank_nodes = doc.xpath("//table[@class='top-ranking-table']/tr[@class='ranking-list']")
      lowest = 100
      break if rank_nodes.any? do |r|
        score, mal_id, rank = process_rank(r)
        return true unless score <= lowest + 1
        lowest = score

        create_score(mal_id, score, rank)
        false
      end
      i += 50
    end
  end

  def self.process_rank(rank_node)
    rank = rank_node.at_xpath(".//td[contains(@class, 'rank')]/span").content
    detail_node = rank_node.at_xpath(".//td[contains(@class, 'title')]//div[@class='detail']")
    mal_id = detail_node.at_xpath(".//div[starts-with(@id, 'info')]")["id"].sub("info", "")
    score = rank_node.at_xpath(".//td[starts-with(@class, 'score')]//span").content.to_f

    [score, mal_id, rank]
  end

  def self.create_score(mal_id, score, rank)
    anime = Anime.find_by(mal_id: mal_id)

    return unless anime

    puts "Adding MAL score of #{score} for #{anime.title} to the database."
    MalScore.create(rank: rank, score: score, anime: anime)
    anime.latest_mal_score = score
    anime.latest_mal_rank = rank
    anime.save
  end
end
