# frozen_string_literal: true

class ContentPartnersController < ApplicationController
  def index
    @content_partners = ContentPartner.order(:name).page(params[:page])
  end

  def new
    @content_partner  = ContentPartner.new
  end

  def show
    @content_partner = ContentPartner.find(params[:id])
    @extraction_definitions = @content_partner.extraction_definitions.order(created_at: :desc).page(params[:page])
  end

  def edit
    @content_partner = ContentPartner.find(params[:id])
  end

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
    @content_partner = ContentPartner.find(params[:id])

    if @content_partner.update(content_partner_params)
      redirect_to content_partners_path
    else
      render 'show'
    end
  end

  private

  def content_partner_params
    params.require(:content_partner).permit(:name)
  end
end
