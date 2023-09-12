# frozen_string_literal: true

class TransformationDefinitionsController < ApplicationController
  include LastEditedBy

  before_action :find_pipeline
  before_action :find_harvest_definition
  before_action :find_transformation_definition, only: %w[show edit update destroy]
  before_action :find_extraction_jobs, only: %w[new create edit update]
  before_action :find_referrer

  def show
    @fields = @transformation_definition.fields.order(created_at: :desc).map(&:to_h)
    @props = transformation_app_state
  end

  def new
    @transformation_definition = TransformationDefinition.new(kind: params[:kind])
  end

  def edit; end

  def create
    @transformation_definition = TransformationDefinition.new(transformation_definition_params)

    if @transformation_definition.save
      @harvest_definition.update(transformation_definition_id: @transformation_definition.id)

      redirect_to pipeline_harvest_definition_transformation_definition_path(
        @pipeline, @harvest_definition, @transformation_definition
      ), notice: t('.success')
    else
      flash.alert = t('.failure')

      render :new
    end
  end

  def update
    if @transformation_definition.update(transformation_definition_params)
      flash.notice = t('.success')

      if @referrer.present?
        redirect_to pipeline_path(@referrer)
      else
        redirect_to pipeline_harvest_definition_transformation_definition_path(@pipeline, @harvest_definition,
                                                                               @transformation_definition)
      end
    else
      flash.alert = t('.failure')
      render 'edit'
    end
  end

  def destroy
    if @transformation_definition.destroy
      redirect_to pipeline_path(@pipeline), notice: t('.success')
    else
      flash.alert = t('.failure')
      redirect_to pipeline_harvest_definition_transformation_definition_path(@pipeline, @harvest_definition,
                                                                             @transformation_definition)
    end
  end

  def test
    @transformation_definition = TransformationDefinition.new(transformation_definition_params)

    render json: {
      result: (@transformation_definition.records.first || []),
      format: @transformation_definition.extraction_job.extraction_definition.format
    }
  end

  private

  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end

  def find_harvest_definition
    @harvest_definition = HarvestDefinition.find(params[:harvest_definition_id])
  end

  def find_referrer
    return if params[:referrer_id].blank?

    @referrer = Pipeline.find(params[:referrer_id])
  end

  def find_transformation_definition
    @transformation_definition = TransformationDefinition.find(params[:id])
  end

  def find_extraction_jobs
    extraction_definitions = if params['kind'] == 'enrichment' || @transformation_definition&.kind == 'enrichment'
                               ExtractionDefinition.all.enrichment
                             else
                               ExtractionDefinition.all.harvest
                             end

    @extraction_jobs = extraction_definitions.map do |ed|
      [ed.name, ed.extraction_jobs.map { |job| [job.name, job.id] }]
    end
  end

  def transformation_definition_params
    safe_params = params.require(:transformation_definition).permit(
      :pipeline_id,
      :content_source_id,
      :name,
      :extraction_job_id,
      :record_selector,
      :kind
    )
    merge_last_edited_by(safe_params)
  end
end
