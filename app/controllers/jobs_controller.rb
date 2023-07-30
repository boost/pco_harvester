# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :find_pipeline

  def index
    @harvest_jobs = paginate_and_filter_jobs(@pipeline.harvest_jobs.joins(:harvest_definition).where(harvest_definition: { kind: 'harvest' }))

    @enrichment_jobs = paginate_and_filter_jobs(@pipeline.harvest_jobs.joins(:harvest_definition).where(harvest_definition: { kind: 'enrichment' }))
  end

  private

  def find_pipeline
    @pipeline = Pipeline.find(params[:pipeline_id])
  end
end
