# frozen_string_literal: true

class HarvestJobsController < ApplicationController
  before_action :find_pipeline
  before_action :find_harvest_definition
  before_action :find_harvest_job, only: %i[show cancel]

  def show; end

  def cancel
    if @harvest_job.cancelled!
      @harvest_job.extraction_job.cancelled!
      flash.notice = 'Harvest job cancelled successfully'
    else
      flash.alert = 'There was an issue cancelling the harvest job'
    end

    redirect_to pipeline_jobs_path(@pipeline)
  end

  private


  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end

  def find_harvest_definition
    @harvest_definition = HarvestDefinition.find(params[:harvest_definition_id])
  end

  def find_harvest_job
    @harvest_job = HarvestJob.find(params[:id])
  end

  def harvest_job_params
    params.require(:harvest_job).permit(:extraction_job_id, :destination_id, :key, :page_type, :pages,
                                        harvest_definitions_to_run: [])
  end
end
