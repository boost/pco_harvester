# frozen_string_literal: true

class ContentPartnersController < ApplicationController
  before_action :find_content_partner, only: %i[show edit update]

  def index
    @content_partners = ContentPartner.order(:name).page(params[:page])
  end

  def show
    @extraction_definitions = @content_partner.extraction_definitions.order(created_at: :desc).page(params[:page])

    @transformation_definitions = @content_partner.transformation_definitions.order(created_at: :desc).page(params[:page])

    @harvest_definitions = @content_partner.harvest_definitions.order(created_at: :desc).page(params[:page])
  end

  def new
    @content_partner = ContentPartner.new
  end

  def edit; end

  def create
    @content_partner = ContentPartner.new(content_partner_params)

    if @content_partner.save
      redirect_to content_partners_path, notice: 'Content Partner created successfully'
    else
      flash.alert = 'There was an issue creating your Content Partner'
      render :new
    end
  end

  def update
    if @content_partner.update(content_partner_params)
      redirect_to content_partners_path, notice: 'Content Partner updated successfully'
    else
      flash.alert = 'There was an issue updating your Content Partner'
      render :edit
    end
  end

  private

  def content_partner_params
    params.require(:content_partner).permit(:name)
  end

  def find_content_partner
    @content_partner = ContentPartner.find(params[:id])
  end
end
