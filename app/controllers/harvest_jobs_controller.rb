# frozen_string_literal: true

class HarvestJobsController < ApplicationController
  before_action :find_pipeline
  before_action :find_harvest_definition
  before_action :find_harvest_job, only: %i[show cancel]

  def show; end

  def create
    if should_queue_harvest_job?
      @harvest_job = HarvestJob.new(harvest_job_params)

      if @harvest_job.save
        HarvestWorker.perform_async(@harvest_job.id)

        flash.notice = 'Harvest job queued successfuly'
      else
        flash.alert = 'There was an issue launching the harvest job'
      end
    else
      @pipeline.enrichments.each do |enrichment|
        next unless should_queue_job?(enrichment.id)

        enrichment_job = HarvestJob.create(
          harvest_definition: enrichment,
          destination_id: harvest_job_params['destination_id'],
          key: "#{harvest_job_params['harvest_key']}__enrichment-#{enrichment.id}",
          harvest_definitions_to_run: harvest_job_params['harvest_definitions_to_run']
        )

        HarvestWorker.perform_async(enrichment_job.id)
      end
      
      flash.notice = 'Enrichment jobs queued successfuly'
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

  def should_queue_harvest_job?
    should_queue_job?(@pipeline.harvest.id)
  end

  def should_queue_job?(id)
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
    params.require(:harvest_job).permit(:extraction_job_id, :harvest_definition_id, :destination_id, :key, :page_type, :pages, harvest_definitions_to_run: [])
  end
end
