# frozen_string_literal: true

class ContentSourcesController < ApplicationController
  before_action :find_content_source, only: %i[show edit update]

  def index
    @content_sources = ContentSource.order(:name).page(params[:page])
  end

  def show
    @harvest_extraction_definitions = @content_source.extraction_definitions.originals.harvests.order(created_at: :desc).page(params[:page])
    @enrichment_extraction_definitions = @content_source.extraction_definitions.originals.enrichments.order(created_at: :desc).page(params[:page])

    @harvest_transformation_definitions = @content_source.transformation_definitions.originals.harvests.order(created_at: :desc).page(params[:page])
    @enrichment_transformation_definitions = @content_source.transformation_definitions.originals.enrichments.order(created_at: :desc).page(params[:page])

    @harvest_definitions = @content_source.harvest_definitions.harvests.order(created_at: :desc).page(params[:page])
    @enrichment_definitions = @content_source.harvest_definitions.enrichments.order(created_at: :desc).page(params[:page])
  end

  def new
    @content_source = ContentSource.new
  end

  def edit; end

  def create
    @content_source = ContentSource.new(content_source_params)

    if @content_source.save
      redirect_to content_sources_path, notice: 'Content Source created successfully'
    else
      flash.alert = 'There was an issue creating your Content Source'
      render :new
    end
  end

  def update
    if @content_source.update(content_source_params)
      redirect_to content_sources_path, notice: 'Content Source updated successfully'
    else
      flash.alert = 'There was an issue updating your Content Source'
      render :edit
    end
  end

  private

  def content_source_params
    params.require(:content_source).permit(:name)
  end

  def find_content_source
    @content_source = ContentSource.find(params[:id])
  end
end
