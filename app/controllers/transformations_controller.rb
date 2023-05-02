# frozen_string_literal: true

class TransformationsController < ApplicationController
  before_action :find_content_partner

  def show
    @transformation = Transformation.find(params[:id])
    @raw_data = @transformation.records.first
    @transformation_preview = {}
  end
  
  def new
    @transformation = Transformation.new
    @jobs = @content_partner.extraction_definitions.flat_map(&:jobs)
  end

  def create
    @transformation = Transformation.new(transformation_params)

    if @transformation.save
      redirect_to content_partner_path(@content_partner), notice: 'Transformation created successfully'
    else
      flash.alert = 'There was an issue creating your Transformation'

      
      @jobs = @content_partner.extraction_definitions.flat_map(&:jobs)
      render :new
    end
  end

  private

  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end

  def transformation_params
    params.require(:transformation).permit(:content_partner_id, :name, :job_id, :record_selector)
  end
end
