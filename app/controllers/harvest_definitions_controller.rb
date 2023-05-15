# frozen_string_literal: true

class HarvestDefinitionsController < ApplicationController
  before_action :find_content_partner
  before_action :find_harvest_definition, only: %i[show edit update destroy]
  before_action :find_destinations

  def show; end

  def edit; end

  def new
    @harvest_definition = HarvestDefinition.new
  end

  def create
    @harvest_definition = HarvestDefinition.new(harvest_definition_params)

    if @harvest_definition.save
      redirect_to content_partner_path(@content_partner), notice: 'Harvest Definition created successfully'
    else
      flash.alert = 'There was an issue creating your Harvest Definition'
      render :new
    end
  end

  def update
    if @harvest_definition.update(harvest_definition_params)
      flash.notice = 'Harvest Definition updated successfully'
      redirect_to content_partner_harvest_definition_path(@content_partner, @harvest_definition)
    else
      flash.alert = 'There was an issue updating your Harvest Definition'
      render 'edit'
    end
  end

  def destroy
    if @harvest_definition.destroy
      redirect_to content_partner_path(@content_partner), notice: 'Harvest Definition deleted successfully'
    else
      flash.alert = 'There was an issue deleting your Harvest Definition'
      redirect_to content_partner_harvest_definition_path(@content_partner, @harvest_definition)
    end
  end

  private

  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end

  def find_destinations
    @destinations = Destination.all
  end

  def find_harvest_definition
    @harvest_definition = HarvestDefinition.find(params[:id])
  end

  def harvest_definition_params
    params.require(:harvest_definition).permit(:name, :content_partner_id, :extraction_definition_id, :job_id, :transformation_definition_id, :destination_id)
  end
end
