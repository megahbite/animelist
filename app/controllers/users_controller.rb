# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.order(:reddit_name).page(params[:page])
  end
end
