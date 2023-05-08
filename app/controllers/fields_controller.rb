# frozen_string_literal: true

class FieldsController < ApplicationController
  before_action :find_field, only: %i[update destroy]

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

    render json: {}, status: 200
  end

  def run
    record = params['record']
    fields = params['fields'].map { |id| Field.find(id) }

    transformed_record = fields.each_with_object({}) do |field, transformed_record|
      transformed_record[field.name] = Transformation::Execution.new(record, field).call
    end

    render json: transformed_record
  end

  private

  def find_field
    @field = Field.find(params[:id])
  end

  def field_params
    params.require(:field).permit(:name, :block, :transformation_definition_id)
  end
end
