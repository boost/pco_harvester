# frozen_string_literal: true

class FieldsController < ApplicationController
  before_action :find_field, only: %i[update destroy]
  before_action :find_fields, only: %i[run]
  before_action :find_transformation_definition, only: %i[run]

  def create
    @field = Field.new(field_params)

    @field.save!

    render json: @field.to_json
  end

  def update
    @field.update(field_params)

    render json: @field
  end

  def destroy
    @field.destroy!

    render json: {}, status: :ok
  end

  def run
    record = @transformation_definition.records(params[:page].to_i)[params['record'].to_i - 1]

    provided_fields = Field.find(params['fields'])

    fields = provided_fields.select(&:field?)
    reject_conditions = provided_fields.select(&:reject_if?)
    delete_conditions = provided_fields.select(&:delete_if?)

    transformation = Transformation::Execution.new([record], fields, reject_conditions, delete_conditions).call.first

    render json: {
      rawRecordSlice: RawRecordSlice.new(@transformation_definition, params[:page], params[:record]).call,
      transformation:
    }
  end

  private

  def find_transformation_definition
    @transformation_definition = TransformationDefinition.find(params[:transformation_definition_id])
  end

  def find_fields
    @fields = Field.where(id: params['fields'])
  end

  def find_field
    @field = Field.find(params[:id])
  end

  def field_params
    params.require(:field).permit(:name, :block, :transformation_definition_id, :kind)
  end
end
