# frozen_string_literal: true

class ContentPartnersController < ApplicationController
  def index
    @content_partners = ContentPartner.order(:name).page(params[:page])
    @content_partner  = ContentPartner.new
  end

  def show
    @content_partner = ContentPartner.find(params[:id])
  end

  def create
    @content_partner = ContentPartner.create(content_partner_params)

    @content_partner.save

    redirect_to content_partners_path
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
