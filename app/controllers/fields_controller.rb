# frozen_string_literal: true

class FieldsController < ApplicationController
  skip_before_action :verify_authenticity_token

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

  private

  def find_field
    @field = Field.find(params[:id])
  end

  def field_params
    params.require(:field).permit(:name, :block, :transformation_definition_id)
  end
end
