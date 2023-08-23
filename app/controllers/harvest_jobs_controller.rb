# frozen_string_literal: true

class HarvestJobsController < ApplicationController
  before_action :find_pipeline
  before_action :find_harvest_definition
  before_action :find_harvest_job, only: %i[show cancel]

  def show; end

  def create
    [@pipeline.harvest, @pipeline.enrichments].flatten.each do |definition|
      next if definition.nil?
      next unless should_queue_job?(definition.id)

      job_params = harvest_job_params.to_h

      job_params[:harvest_definition_id] = definition.id
      job_params[:key] = "#{harvest_job_params['key']}__enrichment-#{definition.id}" if definition.enrichment?
      job = HarvestJob.new(job_params)

      if job.save
        HarvestWorker.perform_async(job.id)
        flash.notice = 'Job queued successfully'
      else
        flash.alert = 'There was an issue queueing your job'
      end

      # If the user has scheduled a harvest we do not need to enqueue the enrichments now
      # as they will be enqueued once the harvest job has finished.
      break if definition.harvest?
    end

    redirect_to pipeline_jobs_path(@pipeline)
  end

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

  def should_queue_job?(id)
    return false if harvest_job_params['harvest_definitions_to_run'].nil?

    harvest_job_params['harvest_definitions_to_run'].map(&:to_i).include?(id)
  end

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
