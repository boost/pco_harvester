# frozen_string_literal: true

class FieldsController < ApplicationController
  def create
    @field = Field.new(field_params)

    if @field.save
      render json: @field.to_json
    end
  end

  private

  def field_params
    params.require(:field).permit(:name, :block, :transformation_id)
  end
end
