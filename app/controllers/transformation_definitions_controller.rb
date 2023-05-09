# frozen_string_literal: true

class TransformationDefinitionsController < ApplicationController
  before_action :find_content_partner
  before_action :find_transformation_definition, only: %w[show edit update destroy]
  before_action :find_jobs, only: %w[new create edit update]

  def show
    @fields = @transformation_definition.fields.map { |field| { id: field.id, name: field.name, block: field.block } }

    @props = {
      entities: {
        fields: {
          ids: @transformation_definition.fields.map(&:id),
          entities: @fields.index_by { |field| field[:id] }
        },
        appDetails: {
          rawRecord: @transformation_definition.records.first,
          transformedRecord: {},
          contentPartner: @content_partner,
          transformationDefinition: @transformation_definition,
        }
      },
      ui: {
        fields: {
          ids: @transformation_definition.fields.map(&:id),
          entities: @fields.map do |field|
            { id: field[:id], saved: true, deleting: false, saving: false, running: false }
          end.index_by { |field| field[:id] }
        }
      }
    }.to_json
  end

  def edit; end

  def new
    @transformation_definition = TransformationDefinition.new
  end

  def create
    @transformation_definition = TransformationDefinition.new(transformation_definition_params)

    if @transformation_definition.save
      redirect_to content_partner_path(@content_partner), notice: 'Transformation Definition created successfully'
    else
      flash.alert = 'There was an issue creating your Transformation Definition'

      render :new
    end
  end

  def update
    if @transformation_definition.update(transformation_definition_params)
      flash.notice = 'Transformation Definition updated successfully'
      redirect_to content_partner_transformation_definition_path(@content_partner, @transformation_definition)
    else
      flash.alert = 'There was an issue updating your Transformation Definition'
      render 'edit'
    end
  end

  def destroy
    if @transformation_definition.destroy
      redirect_to content_partner_path(@content_partner), notice: 'Transformation Definition deleted successfully'
    else
      flash.alert = 'There was an issue deleting your Transformation Definition'
      redirect_to content_partner_transformation_definition_path(@content_partner, @transformation_definition)
    end
  end

  def test
    @transformation_definition = TransformationDefinition.new(transformation_definition_params)
    render json: @transformation_definition.records.first || []
  end

  private

  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end

  def find_transformation_definition
    @transformation_definition = TransformationDefinition.find(params[:id])
  end

  def find_jobs
    @jobs = @content_partner.extraction_definitions.map do |ed|
      [ed.name, ed.jobs.map { |job| [job.name, job.id] }]
    end
  end

  def transformation_definition_params
    params.require(:transformation_definition).permit(:content_partner_id, :name, :job_id, :record_selector)
  end
end
