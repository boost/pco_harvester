# frozen_string_literal: true

class PipelineJobsController < ApplicationController
  before_action :find_pipeline
  before_action :find_pipeline_job, only: %i[show cancel]

  def index
    @pipeline_jobs = paginate_and_filter_jobs(@pipeline.pipeline_jobs)
  end

  def show; end

  def create
    @pipeline_job = PipelineJob.new(pipeline_job_params)

    if @pipeline_job.save
      PipelineWorker.perform_async(@pipeline_job.id)
      flash.notice = t('.success')
    else
      flash.alert = t('.failure')
    end

    redirect_to pipeline_pipeline_jobs_path(@pipeline)
  end

  def cancel
    if @pipeline_job.cancelled!
      @pipeline_job.harvest_jobs.each do |harvest_job|
        harvest_job.cancelled!
        harvest_job.extraction_job.cancelled!
      end

      flash.notice = t('.success')
    else
      flash.alert = t('.failure')
    end

    redirect_to pipeline_pipeline_jobs_path(@pipeline)
  end

  private

  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end

  def find_pipeline_job
    @pipeline_job = PipelineJob.find(params[:id])
  end

  def pipeline_job_params
    params.require(:pipeline_job).permit(:pipeline_id, :key, :extraction_job_id, :destination_id, :page_type, :pages,
                                         harvest_definitions_to_run: [])
  end
end
