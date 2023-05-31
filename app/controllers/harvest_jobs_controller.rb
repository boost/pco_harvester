# frozen_string_literal: true

class HarvestJobsController < ApplicationController
  before_action :find_content_source
  before_action :find_harvest_definition
  before_action :find_harvest_job, only: %i[show cancel]

  def show; end

  def create
    @harvest_job = HarvestJob.new(harvest_job_params)

    if @harvest_job.save
      HarvestWorker.perform_async(@harvest_job.id)
      flash.notice = 'Harvest job queued successfuly'
    else
      flash.alert = 'There was an issue launching the harvest job'
      render :new
    end

    redirect_to content_source_harvest_definition_harvest_job_path(@content_source, @harvest_definition, @harvest_job)
  end

  def cancel
    if @harvest_job.cancelled!
      @harvest_job.extraction_job.cancelled!
      flash.notice = 'Harvest job cancelled successfully'
    else
      flash.alert = 'There was an issue cancelling the harvest job'
    end

    redirect_to content_source_harvest_definition_path(@content_source, @harvest_definition)
  end

  private

  def find_content_source
    @content_source = ContentSource.find(params[:content_source_id])
  end

  def find_harvest_definition
    @harvest_definition = HarvestDefinition.find(params[:harvest_definition_id])
  end

  def find_harvest_job
    @harvest_job = HarvestJob.find(params[:id])
  end

  def harvest_job_params
    params.require(:harvest_job).permit(:extraction_job_id, :harvest_definition_id)
  end
end
