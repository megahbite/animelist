class ProcessRedditUsers
  def self.fetch_user_flairs(subreddit)
    new_posts_json = Faraday.get "https://www.reddit.com/r/#{subreddit}/new.json"
    new_posts = JSON.parse new_posts_json.body
    post_ids = new_posts["data"]["children"].map { |child| child["data"]["id"] }
    users = {}
    post_ids.each do |post_id|
      comment_authors(subreddit, post_id, users)
    end

    users
  end

  def self.extract_mal_profiles(user_flairs)
    users = {}
    user_flairs.each do |reddit_username, flair|
      flair.match %r{myanimelist\.net/(profile|animelist)/(?<profile>\w+)} do |match|
        users[reddit_username] = match.named_captures["profile"]
      end
    end
    users
  end

  private

  def self.comment_authors(subreddit, post_id, authors_hash)
    comments_json = Faraday.get "https://www.reddit.com/r/#{subreddit}/comments/#{post_id}.json"
    comments = JSON.parse comments_json.body

    comments = comments[1] # The first item is the post metadata again
    comments = comments["data"]["children"]

    comments.each do |comment|
      flatten_authors(authors_hash, comment)
    end

    authors
  end

  def self.flatten_authors(authors_hash, comment)
    authors_hash[comment["data"]["author"]] = comment["data"]["author_flair_text"]
    return unless comment["replies"].is_a? Hash
    comment["replies"]["data"]["children"].each do |child_comment|
      flatten_authors(authors_hash, child_comment)
    end
  end
end