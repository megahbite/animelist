# frozen_string_literal: true

class MangaController < ApplicationController
  decorates_assigned :manga
  def index
    @manga = MangaDecorator.decorate_collection(all_manga)
  end

  def show
    @manga = Manga.find(params[:id])
    @user_scores = UserScore.includes(:user).where(scoreable: @manga)
                            .order(score: :desc, status: :asc, watched: :desc).decorate
  end

  private

  def all_manga
    sort(Manga.where.not(latest_score: 0, latest_mal_score: nil)).page(params[:page])
  end

  def sort(manga_list)
    sort_method = params[:sort]
    sort_direction = "desc".eql?(params[:direction].try(:downcase)) ? "desc" : "asc"

    case sort_method
    when "mal"
      manga_list.order(latest_mal_rank: sort_direction)
    when "difference"
      manga_list.order("(latest_score - latest_mal_score) #{sort_direction}")
    when "title"
      manga_list.order(title: sort_direction)
    else
      manga_list.order(latest_rank: sort_direction)
    end
  end
end
