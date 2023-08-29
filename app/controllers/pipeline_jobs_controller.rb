# frozen_string_literal: true

class PipelineJobsController < ApplicationController
  before_action :find_pipeline

  def show
    @pipeline_job = PipelineJob.find(params[:id])
  end

  def create
    @pipeline_job = PipelineJob.new(pipeline_job_params)

    if @pipeline_job.save
      params['settings']['blocks_to_run'].each do |block|
        PipelineBlockReport.create(pipeline_job: @pipeline_job, harvest_definition_id: block)
      end
    end

    redirect_to pipeline_pipeline_job_path(@pipeline, @pipeline_job)
  end

  private

  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end

  def pipeline_job_params
    params.require(:pipeline_job).permit(:pipeline_id, :key)
  end
end
