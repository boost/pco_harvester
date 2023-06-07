# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.order(username: :desc).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update; end

  def destroy; end

  def two_factor_authentication

  end
end
