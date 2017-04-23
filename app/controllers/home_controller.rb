class HomeController < ApplicationController
  def index
    @front_page = FrontPageAnimesDecorator.decorate(Anime.order(latest_rank: :asc).page params[:page])
  end
end