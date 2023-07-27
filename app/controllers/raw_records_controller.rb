# frozen_string_literal: true

class RawRecordsController < ApplicationController
  before_action :find_fields, only: [:index]
  before_action :find_transformation_definition, only: [:index]

  def index
    record = @transformation_definition.records(params[:page].to_i)[params['record'].to_i]

    transformation = Transformation::Execution.new([record], @fields).call.first

    render json: {
      rawRecordSlice: RawRecordSlice.new(@transformation_definition, params[:page], params[:record]).call,
      transformedRecord: transformation
    }
  end

  private

  def find_fields
    @fields = Field.where(id: params['fields'])
  end

  def find_transformation_definition
    @transformation_definition = TransformationDefinition.find(params[:transformation_definition_id])
  end
end
