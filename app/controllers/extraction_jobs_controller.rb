# frozen_string_literal: true

class ExtractionJobsController < ApplicationController
  before_action :find_pipeline
  before_action :find_harvest_definition
  before_action :find_extraction_definition
  before_action :find_extraction_job, only: %i[show destroy]

  def index
    @extraction_jobs = paginate_and_filter_jobs(@extraction_definition.extraction_jobs)
  end

  def show
    @documents = @extraction_job.documents
    @document = @documents[params[:page]]
  end

  def create
    respond_to do |format|
      format.html { html_create }
      format.json { json_create }
    end
  end

  def destroy
    if @extraction_job.destroy
      flash.notice = t('.success')
      redirect_to pipeline_pipeline_jobs_path(@pipeline)
    else
      flash.alert = t('.failure')
      redirect_to pipeline_harvest_definition_extraction_definition_extraction_job_path(
        @pipeline, @harvest_definition, @extraction_definition, @extraction_job
      )
    end
  end

  private

  def html_create
    @extraction_job = ExtractionJob.new(extraction_definition: @extraction_definition, kind: params[:kind])

    if @extraction_job.save
      ExtractionWorker.perform_async(@extraction_job.id)
      flash.notice = t('.success')
    else
      flash.alert = t('.failure')
    end

    redirect_to pipeline_harvest_definition_extraction_definition_extraction_jobs_path(@pipeline, @harvest_definition,
    @extraction_definition)
  end

  def json_create
    @extraction_job = ExtractionJob.create(extraction_definition: @extraction_definition, kind: params[:kind])
    ExtractionWorker.perform_async(@extraction_job.id)

    if params[:type] == 'transform'
      if @harvest_definition.transformation_definition.present?
        transformation_definition = @harvest_definition.transformation_definition

        transformation_definition.update(extraction_job_id: @extraction_job.id)
      else
        transformation_definition = TransformationDefinition.create(
          extraction_job_id: @extraction_job.id,
          pipeline_id: @pipeline.id,
          record_selector: '*'
        )
  
        @harvest_definition.update(transformation_definition_id: transformation_definition.id)
      end

      render json: transformation_definition
    else
      render json: @extraction_job
    end
  end

  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end

  def find_harvest_definition
    @harvest_definition = HarvestDefinition.find(params[:harvest_definition_id])
  end

  def find_extraction_definition
    @extraction_definition = ExtractionDefinition.find(params[:extraction_definition_id])
  end

  def find_extraction_job
    @extraction_job = @extraction_definition.extraction_jobs.find(params[:id])
  end
end
