# frozen_string_literal: true

class AnimeController < ApplicationController
  decorates_assigned :anime
  def show
    @anime = Anime.find(params[:id])
    @user_scores = UserScore.where(anime: @anime).order(score: :desc, status: :asc, watched: :desc).decorate
  end
end
