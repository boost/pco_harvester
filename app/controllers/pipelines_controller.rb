# frozen_string_literal: true

class PipelinesController < ApplicationController
  before_action :assign_sort_by, only: %w[index create]
  before_action :assign_pipelines, only: %w[index]

  def index
    @pipeline = Pipeline.new
  end

  def create
    @pipeline = Pipeline.new(pipeline_params)

    if @pipeline.save
      redirect_to pipeline_path(@pipeline), notice: 'Pipeline created successfully'
    else
      flash.now[:alert] = 'There was an issue creating your Pipeline'
      assign_pipelines
      render :index
    end
  end

  def show
    @pipeline = Pipeline.find(params[:id])
  end

  private

  def assign_sort_by
    @sort_by = { name: :asc }
    @sort_by = { updated_at: :desc } if params['sort_by'] == 'updated_at'
  end

  def assign_pipelines
    @pipelines = Pipeline.order(@sort_by).page(params[:page])
  end

  def pipeline_params
    params.require(:pipeline).permit(:name, :description)
  end
end
