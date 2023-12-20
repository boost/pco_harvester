# frozen_string_literal: true

class StopConditionsController < ApplicationController
  include LastEditedBy

  def create
    @stop_condition = StopCondition.new(stop_condition_params)

    if @stop_condition.save
      render json: @stop_condition
      update_last_edited_by([@stop_condition.extraction_definition])
    else
      render500
    end
  end

  private

  def stop_condition_params
    params.require(:stop_condition).permit(:name, :content, :extraction_definition_id)
  end
end
