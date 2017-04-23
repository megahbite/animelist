class AnimeController < ApplicationController
  decorates_assigned :anime
  def show
    @anime = Anime.find(params[:id])
    @user_scores = UserScore.where(anime: @anime).order(score: :desc, status: :asc, watched: :desc, reddit_name: :asc).decorate
  end
end