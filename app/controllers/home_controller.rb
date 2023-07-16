# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to pipelines_path
  end
end
