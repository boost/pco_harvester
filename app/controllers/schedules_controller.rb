# frozen_string_literal: true

class SchedulesController < ApplicationController
  include LastEditedBy

  before_action :find_pipeline
  before_action :find_destinations, only: %i[new create]

  def index
    @schedules = @pipeline.schedules
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)

    if @schedule.save
      redirect_to pipeline_path(@pipeline), notice: t('.success')
    else
      flash.alert = t('.failure')
      render :new
    end
  end

  private

  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end

  def find_destinations
    @destinations = Destination.all
  end

  def schedule_params
    params.require(:schedule).permit(:frequency, :time, :day, :day_of_the_month,
                                     :pipeline_id, :destination_id, harvest_definitions_to_run: [])
  end
end
