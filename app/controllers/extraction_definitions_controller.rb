# frozen_string_literal: true

class ExtractionDefinitionsController < ApplicationController
  before_action :find_pipeline
  before_action :find_referrer
  before_action :find_harvest_definition
  before_action :find_extraction_definition, only: %i[edit update]
  before_action :find_destinations, only: %i[new create edit update]

  def new
    @extraction_definition = ExtractionDefinition.new(kind: params[:kind])
  end

  def edit; end

  def create
    @extraction_definition = ExtractionDefinition.new(extraction_definition_params)

    if @extraction_definition.save
      @harvest_definition.update(extraction_definition_id: @extraction_definition.id)

      @extraction_job = ExtractionJob.create(extraction_definition: @extraction_definition, kind: 'sample')
      ExtractionWorker.perform_async(@extraction_job.id)
      
      redirect_to pipeline_path(@pipeline), notice: 'Extraction Definition created successfully'
    else
      flash.alert = 'There was an issue creating your Extraction Definition'
      render :new
    end
  end

  def update
    if @extraction_definition.update(extraction_definition_params)
      flash.notice = 'Extraction Definition updated successfully'

      if @referrer.present?
        redirect_to pipeline_path(@referrer)
      else
        redirect_to pipeline_path(@pipeline)
      end
    else
      flash.alert = 'There was an issue updating your Extraction Definition'
      render 'edit'
    end
  end

  def test
    @extraction_definition = ExtractionDefinition.new(extraction_definition_params.except('headers_attributes'))

    if extraction_definition_params.include?('headers_attributes')
      extraction_definition_params['headers_attributes'].each do |key, header_attributes|
        @extraction_definition.headers << Header.new(header_attributes)
      end
    end

    render json: Extraction::DocumentExtraction.new(@extraction_definition).extract
  end

  def test_record_extraction
    @extraction_definition = ExtractionDefinition.new(extraction_definition_params)

    render json: Extraction::RecordExtraction.new(@extraction_definition, 1).extract
  end

  def test_enrichment_extraction
    @extraction_definition = ExtractionDefinition.new(extraction_definition_params)

    api_records = Extraction::RecordExtraction.new(@extraction_definition, 1).extract
    records = JSON.parse(api_records.body)['records']

    render json: Extraction::EnrichmentExtraction.new(@extraction_definition, records.first, 1).extract
  end

  def destroy
    if @extraction_definition.destroy
      redirect_to pipeline_path(@pipeline), notice: 'Extraction Definition deleted successfully'
    else
      flash.alert = 'There was an issue deleting your Extraction Definition'
      redirect_to pipeline_extraction_definition_path(@pipeline, @extraction_definition)
    end
  end

  private

  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end

  def find_referrer
    return if params[:referrer_id].blank?

    @referrer = Pipeline.find(params[:referrer_id])
  end

  def find_harvest_definition
    @harvest_definition = HarvestDefinition.find(params[:harvest_definition_id])
  end

  def find_extraction_definition
    @extraction_definition = ExtractionDefinition.find(params[:id])
  end

  def find_destinations
    @destinations = Destination.all
  end

  def extraction_definition_params
    params.require(:extraction_definition).permit(
      :pipeline_id,
      :name, :format, :base_url, :throttle, :pagination_type,
      :page_parameter, :per_page_parameter, :page, :per_page,
      :total_selector,
      :kind, :destination_id, :source_id, :enrichment_url,
      :token_parameter, :token_value, :next_token_path, :initial_params,
      headers_attributes: [:id, :name, :value]
    )
  end
end
