class AnimeController < ApplicationController
  def show
    @anime = Anime.find(params[:id]).decorate
    @user_scores = UserScore.where(anime: @anime).order(score: :desc, status: :asc, watched: :desc, reddit_name: :asc).decorate
  end
end