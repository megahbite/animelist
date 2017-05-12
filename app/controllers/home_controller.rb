# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @front_page = FrontPageAnimesDecorator.decorate(anime)
  end

  def search
    search_param = params[:q]

    @users = User.where("reddit_name ILIKE :q OR mal_name ILIKE :q", q: "%#{search_param}%").order(:reddit_name)

    @anime = Anime.where("title ILIKE :q OR synonyms ILIKE :q", q: "%#{search_param}%").order(:title)

    @manga = Manga.where("title ILIKE :q OR synonyms ILIKE :q", q: "%#{search_param}%").order(:title)
  end

  private

  def anime
    sort(Anime.where.not(latest_score: 0, latest_mal_score: nil)).page(params[:page])
  end

  def sort(anime_list)
    sort_method = params[:sort]
    sort_direction = "desc".eql?(params[:direction].try(:downcase)) ? "desc" : "asc"

    case sort_method
    when "mal"
      anime_list.order(latest_mal_rank: sort_direction)
    when "difference"
      anime_list.order("(latest_score - latest_mal_score) #{sort_direction}")
    when "title"
      anime_list.order(title: sort_direction)
    else
      anime_list.order(latest_rank: sort_direction)
    end
  end
end
