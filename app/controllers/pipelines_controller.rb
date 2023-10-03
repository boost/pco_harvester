# frozen_string_literal: true

class PipelinesController < ApplicationController
  include LastEditedBy

  before_action :assign_sort_by, only: %w[index create]
  before_action :find_pipeline, only: %w[show destroy update clone]
  before_action :assign_show_variables, only: %w[show update]

  def index
    @pipelines = Pipeline.order(@sort_by).page(params[:page])
    @pipeline = Pipeline.new
  end

  def show; end

  def create
    @pipeline = Pipeline.new(pipeline_params)

    if @pipeline.save
      redirect_to pipeline_path(@pipeline), notice: t('.success')
    else
      flash.alert = t('.failure')
      @pipelines = Pipeline.order(@sort_by).page(params[:page])
      render :index
    end
  end

  def update
    if @pipeline.update(pipeline_params)
      redirect_to pipeline_path(@pipeline)
    else
      flash.alert = t('.failure')
      render :show
    end
  end

  def destroy
    if @pipeline.destroy
      redirect_to pipelines_path, notice: t('.success')
    else
      flash.alert = t('.failure')
      redirect_to pipeline_path(@pipeline)
    end
  end

  def clone
    cloned_pipeline = Pipeline.new(pipeline_params)

    if cloned_pipeline.save

      @pipeline.harvest_definitions.each do |harvest_definition|
        harvest_definition.clone(cloned_pipeline).save!
      end

      redirect_to pipeline_path(cloned_pipeline), notice: t('.success')
    else
      flash.alert = t('.failure')
      redirect_to pipeline_path(@pipeline)
    end
  end

  private

  def assign_show_variables
    @harvest_definition = @pipeline.harvest || HarvestDefinition.new(pipeline: @pipeline)
    @pipeline_job = PipelineJob.new

    @enrichment_definition = HarvestDefinition.new(pipeline: @pipeline)

    if @harvest_definition&.extraction_definition.present?
      @extraction_jobs = @harvest_definition.extraction_definition.extraction_jobs.completed.order(created_at: :desc)
    end

    @destinations = Destination.all
  end

  def find_pipeline
    @pipeline = Pipeline.find(params[:id])
  end

  def assign_sort_by
    @sort_by = { name: :asc }
    @sort_by = { updated_at: :desc } if params['sort_by'] == 'updated_at'
  end

  def pipeline_params
    safe_params = params.require(:pipeline).permit(:name, :description)
    merge_last_edited_by(safe_params)
  end
end
