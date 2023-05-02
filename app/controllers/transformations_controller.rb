# frozen_string_literal: true

class TransformationsController < ApplicationController
  before_action :find_content_partner
  before_action :find_transformation, only: %w(show edit update)
  before_action :find_jobs, only: %w(edit new create update)

  def show
    @raw_data = @transformation.records.first
    @transformation_preview = {}
  end

  def edit; end
  
  def new
    @transformation = Transformation.new
  end

  def create
    @transformation = Transformation.new(transformation_params)

    if @transformation.save
      redirect_to content_partner_path(@content_partner), notice: 'Transformation created successfully'
    else
      flash.alert = 'There was an issue creating your Transformation'
      
      render :new
    end
  end
  
  def update
    if @transformation.update(transformation_params)
      flash.notice = 'Transformation updated successfully'
      redirect_to content_partner_transformation_path(@content_partner, @transformation)
    else
      flash.alert = 'There was an issue updating your Transformation'
      render 'edit'
    end
  end

  private
  
  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end

  def find_transformation
    @transformation = Transformation.find(params[:id])
  end

  def find_jobs
    @jobs = @content_partner.extraction_definitions.flat_map(&:jobs)
  end

  def transformation_params
    params.require(:transformation).permit(:content_partner_id, :name, :job_id, :record_selector)
  end
end
