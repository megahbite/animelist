class HomeController < ApplicationController
  def index
    @front_page = FrontPageAnimesDecorator.decorate(Anime.order(rank: :asc).page params[:page])
  end
end