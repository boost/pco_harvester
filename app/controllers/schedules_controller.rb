# frozen_string_literal: true

class SchedulesController < ApplicationController
  before_action :find_pipeline

  def index
    @schedules = @pipeline.schedules
  end

  private

  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end
end
