class AnimeController < ApplicationController
  decorates_assigned :anime
  def show
    @anime = Anime.find(params[:id])
    @user_scores = UserScore.joins(:user).where(anime: @anime).order(score: :desc, status: :asc, watched: :desc, "users.reddit_name" => :asc).decorate
  end
end