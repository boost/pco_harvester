# frozen_string_literal: true

class ExtractionDefinitionsController < ApplicationController
  before_action :find_content_partner
  before_action :find_extraction_definition, only: %i[show edit update destroy update_harvest_definitions]
  before_action :find_destinations, only: %i[new create edit update]

  def show
    @extraction_jobs = paginate_and_filter_jobs(@extraction_definition.extraction_jobs)

    @related_harvest_definitions = @extraction_definition.copies.map do |copy|
      HarvestDefinition.find_by(extraction_definition_id: copy.id)
    end.compact
  end

  def new
    @extraction_definition = ExtractionDefinition.new(kind: params[:kind])
  end

  def edit; end

  def create
    @extraction_definition = ExtractionDefinition.new(extraction_definition_params)
    if @extraction_definition.save
      redirect_to content_partner_path(@content_partner), notice: 'Extraction Definition created successfully'
    else
      flash.alert = 'There was an issue creating your Extraction Definition'
      render :new
    end
  end

  def update
    if @extraction_definition.update(extraction_definition_params)
      flash.notice = 'Extraction Definition updated successfully'
      redirect_to content_partner_extraction_definition_path(@content_partner, @extraction_definition)
    else
      flash.alert = 'There was an issue updating your Extraction Definition'
      render 'edit'
    end
  end

  def update_harvest_definitions
    @extraction_definition.copies.each do |copy|
      harvest_definition = HarvestDefinition.find_by(extraction_definition: copy)
      harvest_definition.update_extraction_definition_clone(@extraction_definition)
    end

    flash.notice = 'Harvest definitions updated.'
    redirect_to content_partner_extraction_definition_path(@content_partner, @extraction_definition)
  end

  def test
    @extraction_definition = ExtractionDefinition.new(extraction_definition_params)

    render json: Extraction::DocumentExtraction.new(@extraction_definition).extract
  end

  def test_record_extraction
    @extraction_definition = ExtractionDefinition.new(extraction_definition_params)

    render json: Extraction::RecordExtraction.new(@extraction_definition).extract
  end

  def test_enrichment_extraction
    @extraction_definition = ExtractionDefinition.new(extraction_definition_params)

    api_records = Extraction::RecordExtraction.new(@extraction_definition).extract
    records = JSON.parse(api_records.body)['records']

    render json: Extraction::EnrichmentExtraction.new(@extraction_definition, records.first).extract
  end

  def destroy
    if @extraction_definition.destroy
      redirect_to content_partner_path(@content_partner), notice: 'Extraction Definition deleted successfully'
    else
      flash.alert = 'There was an issue deleting your Extraction Definition'
      redirect_to content_partner_extraction_definition_path(@content_partner, @extraction_definition)
    end
  end

  private

  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end

  def find_extraction_definition
    @extraction_definition = ExtractionDefinition.find(params[:id])
  end

  def find_destinations
    @destinations = Destination.all
  end

  def extraction_definition_params
    params.require(:extraction_definition).permit(
      :content_partner_id,
      :name, :format, :base_url, :throttle, :pagination_type,
      :page_parameter, :per_page_parameter, :page, :per_page,
      :total_selector,
      :kind, :destination_id, :source_id, :enrichment_url
    )
  end
end
