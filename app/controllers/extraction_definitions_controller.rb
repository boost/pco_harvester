# frozen_string_literal: true

class ExtractionDefinitionsController < ApplicationController
  before_action :find_content_partner
  before_action :find_extraction_definition, only: %i[show]

  def show
  end

  def new
    @extraction_definition = ExtractionDefinition.new
  end

  def create
    @extraction_definition = ExtractionDefinition.new(extraction_definitions_params)
    if @extraction_definition.save
      redirect_to content_partner_path(@content_partner), notice: 'Extraction Definition created successfully'
    else
      flash.alert = 'There was an issue creating your Extraction Definition'
      render :new
    end
  end

  private

  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end

  def find_extraction_definition
    @extraction_definition = ExtractionDefinition.find(params[:id])
  end

  def extraction_definitions_params
    params.require(:extraction_definition).permit(:content_partner_id, :name)
  end
end
