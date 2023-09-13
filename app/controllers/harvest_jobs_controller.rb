# frozen_string_literal: true

class HarvestJobsController < ApplicationController
  before_action :find_pipeline
  before_action :find_harvest_definition
  before_action :find_harvest_job, only: %i[show cancel]

  def show; end

  def create
    [@pipeline.harvest, @pipeline.enrichments].flatten.each do |definition|
      job = build_job(definition)
      next if job.nil?

      save_and_enqueue_job(job)

      # If the user has scheduled a harvest we do not need to enqueue the enrichments now
      # as they will be enqueued once the harvest job has finished.
      break if definition.harvest?
    end

    redirect_to pipeline_jobs_path(@pipeline)
  end

  def cancel
    if @harvest_job.cancelled!
      @harvest_job.extraction_job.cancelled!
      flash.notice = t('.success')
    else
      flash.alert = t('.failure')
    end

    redirect_to pipeline_jobs_path(@pipeline)
  end

  private

  def build_job(definition)
    return if definition.nil?
    return unless should_queue_job?(definition.id)

    job_params = harvest_job_params.to_h

    job_params[:harvest_definition_id] = definition.id
    job_params[:key] = "#{harvest_job_params['key']}__enrichment-#{definition.id}" if definition.enrichment?
    HarvestJob.new(job_params)
  end

  def save_and_enqueue_job(job)
    if job.save
      HarvestWorker.perform_async(job.id)
      flash.notice = t('.success')
    else
      flash.alert = t('.failure')
    end
  end

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
