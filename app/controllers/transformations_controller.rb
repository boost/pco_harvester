# frozen_string_literal: true

class TransformationsController < ApplicationController
  before_action :find_content_partner
  before_action :find_transformation, only: %w(show edit update destroy)
  before_action :find_jobs, only: %w(edit new create update)
  
  skip_before_action :verify_authenticity_token, only: %i[test]

  def show
    @props = {
      entities: {
        rawRecord: @transformation.records.first,
        transformedRecord: @transformation.transformed_records.first,
        fields: @transformation.fields.map { |field| { id: field.id, name: field.name, block: field.block } }
      },
    }.to_json
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

  def destroy
    if @transformation.destroy
      redirect_to content_partner_path(@content_partner), notice: 'Transformation deleted successfully'
    else
      flash.alert = 'There was an issue deleting your Transformation'
      redirect_to content_partner_transformation_path(@content_partner, @transformation)
    end
  end

  def test
    @transformation = Transformation.new(transformation_params)
    render json: @transformation.records.first || []
  end

  private
  
  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end

  def find_transformation
    @transformation = Transformation.find(params[:id])
  end

  def find_jobs
    @jobs = @content_partner.extraction_definitions.map do |ed|
      [ed.name, ed.jobs.map { |job| [job.name, job.id] }]
    end
  end

  def transformation_params
    params.require(:transformation).permit(:content_partner_id, :name, :job_id, :record_selector)
  end
end
