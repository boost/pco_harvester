# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.order(username: :desc).page(params[:page])
  end

  def new; end
  def edit; end
  def create; end
  def update; end
end
