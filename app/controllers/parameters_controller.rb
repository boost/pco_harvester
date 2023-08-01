# frozen_string_literal: true

class ParametersController < ApplicationController
  before_action :find_parameter, only: %i[update destroy]
  
  def create
    @parameter = Parameter.new(parameter_params)

    @parameter.save!

    render json: @parameter
  end

  def update
    @parameter.update(parameter_params)

    render json: @parameter
  end

  def destroy
    @parameter.destroy!

    render json: {}, status: :ok
  end

  private

  def find_parameter
    @parameter = Parameter.find(params[:id])
  end

  def parameter_params
    params.require(:parameter).permit(:name, :content, :request_id, :kind)
  end
end
