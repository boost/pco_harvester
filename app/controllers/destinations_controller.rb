# frozen_string_literal: true

class DestinationsController < ApplicationController
  before_action :find_destination, only: %i(show edit update destroy)
  def index
    @destinations = Destination.order(:name).page(params[:page])
  end

  def show; end

  def new
    @destination = Destination.new
  end

  def create
    @destination = Destination.new(destination_params)

    if @destination.save
      redirect_to destinations_path, notice: 'Destination created successfully'
    else
      flash.alert = 'There was an issue creating your Destination'
      render :new
    end
  end

  def update
    if @destination.update(destination_params)
      flash.notice = 'Destination updated successfully'

      redirect_to destinations_path
    else
      flash.alert = 'There was an issue updating your Destination'

      render 'edit'
    end
  end

  def destroy
    if @destination.destroy
      redirect_to destinations_path, notice: 'Destination deleted successfully'
    else
      flash.alert = 'There was an issue deleting your Destination'

      redirect_to destination_path(@destination)
    end
  end

  private

  def find_destination
    @destination = Destination.find(params[:id])
  end

  def destination_params
    params.require(:destination).permit(:name, :url, :api_key)
  end
end
