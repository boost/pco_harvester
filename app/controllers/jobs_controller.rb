# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :find_pipeline

  def index
    @harvest_extraction_jobs = paginate_and_filter_jobs(@pipeline.harvest.extraction_definition.extraction_jobs)
  end

  private

  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end
end
