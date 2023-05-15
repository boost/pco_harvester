# frozen_string_literal: true

class HarvestJobsController < ApplicationController
  before_action :find_harvest_definition

  def create
    @harvest_job = HarvestJob.new(harvest_definition: @harvest_definition)

    if @harvest_job.save
      HarvestWorker.perform_async(@harvest_job.id)
      flash.notice = 'Job queued successfuly'
    else
      flash.alert = 'There was an issue launching the job'
    end
  end

  private

  def find_harvest_definition
    @harvest_definition = HarvestDefinition.find(params[:harvest_definition_id])
  end
end
