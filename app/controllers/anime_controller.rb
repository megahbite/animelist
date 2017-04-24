# frozen_string_literal: true

class AnimeController < ApplicationController
  decorates_assigned :anime
  def show
    @anime = Anime.find(params[:id])
    @user_scores = UserScore.includes(:user).where(anime: @anime)
                            .order(score: :desc, status: :asc, watched: :desc).decorate
  end
end
