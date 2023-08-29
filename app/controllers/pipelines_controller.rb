# frozen_string_literal: true

class PipelinesController < ApplicationController
  before_action :assign_sort_by, only: %w[index create]
  before_action :find_pipeline, only: %w[show destroy edit update]

  def index
    @pipelines = Pipeline.order(@sort_by).page(params[:page])
    @pipeline = Pipeline.new
  end

  def show
    @harvest_definition = @pipeline.harvest || HarvestDefinition.new(pipeline: @pipeline)
    @harvest_job = HarvestJob.new

    @enrichment_definition = HarvestDefinition.new(pipeline: @pipeline)

    if @harvest_definition&.extraction_definition.present?
      @extraction_jobs = @harvest_definition.extraction_definition.extraction_jobs.completed.order(created_at: :desc)
    end

    @destinations = Destination.all
  end

  def edit; end

  def create
    @pipeline = Pipeline.new(pipeline_params)

    if @pipeline.save
      redirect_to pipeline_path(@pipeline)
    else
      flash.now[:alert] = 'There was an issue creating your Pipeline'
      @pipelines = Pipeline.order(@sort_by).page(params[:page])
      render :index
    end
  end

  def update
    if @pipeline.update(pipeline_params)
      redirect_to pipeline_path(@pipeline), notice: 'Pipeline updated successfully'
    else
      flash.alert = 'There was an issue updating your Pipeline'
      render :edit
    end
  end

  def destroy
    if @pipeline.destroy
      redirect_to pipelines_path, notice: 'Pipeline deleted successfully'
    else
      flash.alert = 'There was an issue deleting your Pipeline'
      redirect_to pipeline_path(@pipeline)
    end
  end

  def run

  end

  private

  def find_pipeline
    @pipeline = Pipeline.find(params[:id])
  end

  def assign_sort_by
    @sort_by = { name: :asc }
    @sort_by = { updated_at: :desc } if params['sort_by'] == 'updated_at'
  end

  def pipeline_params
    params.require(:pipeline).permit(:name, :description)
  end
end
