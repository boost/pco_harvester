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

    render json: {}, status: :ok
  end

  def run
    format = params['format']

    record = if %w[XML HTML].include?(format)
               params['record']
             elsif format == 'JSON'
               params['record'].to_unsafe_h
             end

    providedFields = Field.find(params['fields'])

    fields = providedFields.select(&:field?)
    reject_conditions = providedFields.select(&:reject_if?)
    delete_conditions = providedFields.select(&:delete_if?)

    transformation = Transformation::Execution.new([record], fields, reject_conditions, delete_conditions).call.first

    render json: transformation.to_json
  end

  private

  def find_field
    @field = Field.find(params[:id])
  end

  def field_params
    params.require(:field).permit(:name, :block, :transformation_definition_id, :kind)
  end
end
