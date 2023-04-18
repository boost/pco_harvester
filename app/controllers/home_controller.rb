# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to content_partners_path
  end
end
