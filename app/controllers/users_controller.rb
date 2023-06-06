# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.order(username: :desc).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
end
