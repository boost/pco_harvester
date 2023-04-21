# frozen_string_literal: true

class ExtractionDefinitionsController < ApplicationController
  before_action :find_content_partner
  before_action :find_extraction_definition, only: %i[show edit update destroy]

  skip_before_action :verify_authenticity_token, only: %i[test]

  def show; end

  def new
    @extraction_definition = ExtractionDefinition.new
  end

  def create
    @extraction_definition = ExtractionDefinition.new(extraction_definition_params)
    if @extraction_definition.save
      redirect_to content_partner_path(@content_partner), notice: 'Extraction Definition created successfully'
    else
      flash.alert = 'There was an issue creating your Extraction Definition'
      render :new
    end
  end

  def edit; end

  def update
    if @extraction_definition.update(extraction_definition_params)
      flash.notice = 'Extraction Definition updated successfully'
      redirect_to content_partner_extraction_definition_path(@content_partner, @extraction_definition)
    else
      flash.alert = 'There was an issue updating your Extraction Definition'
      render 'edit'
    end
  end

  def test
    @extraction_definition = ExtractionDefinition.new(extraction_definition_params)

    render json: DocumentExtraction.new(@extraction_definition).extract
  end

  def run
    @job = Job.create(status: 'queued')

    ExtractionJob.perform_async(params[:id], @job.id)
  end

  def destroy
    if @extraction_definition.destroy
      redirect_to content_partner_path(@content_partner), notice: 'Extraction Definition deleted successfully'
    else
      flash.alert = 'There was an issue deleting your Extraction Definition'
      render 'show'
    end
  end

  private

  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end

  def find_extraction_definition
    @extraction_definition = ExtractionDefinition.find(params[:id])
  end

  def extraction_definition_params
    params.require(:extraction_definition).permit(
      :content_partner_id,
      :name, :format, :base_url, :throttle, :pagination_type,
      :page_parameter, :per_page_parameter, :page, :per_page,
      :total_selector
    )
  end
end
