# frozen_string_literal: true

class ContentPartnersController < ApplicationController
  def index
    @content_partners = ContentPartner.order(:name).page(params[:page])
    @content_partner  = ContentPartner.new
  end

  def create
    @content_partner = ContentPartner.create(content_partner_params)

    @content_partner.save!

    redirect_to content_partners_path
  end

  private

  def content_partner_params
    params.require(:content_partner).permit(:name)
  end
end
