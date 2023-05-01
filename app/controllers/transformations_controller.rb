# frozen_string_literal: true

class TransformationsController < ApplicationController
  before_action :find_content_partner
  
  def new
    @transformation = Transformation.new
    @jobs = @content_partner.extraction_definitions.flat_map(&:jobs)
  end

  private

  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end
end
