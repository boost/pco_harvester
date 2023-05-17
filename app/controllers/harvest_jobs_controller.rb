# frozen_string_literal: true

class HarvestJobsController < ApplicationController
  before_action :find_content_partner
  before_action :find_harvest_definition

  def show
    @harvest_job = HarvestJob.find(params[:id])
  end

  def create
    @harvest_job = HarvestJob.new(harvest_job_params.except(:extraction_job_id))

    if @harvest_job.save
      HarvestWorker.perform_async(@harvest_job.id, harvest_job_params[:extraction_job_id])
      flash.notice = 'Job queued successfuly'
    else
      flash.alert = 'There was an issue launching the job'
      render :new
    end

    redirect_to content_partner_harvest_definition_harvest_job_path(@content_partner, @harvest_definition, @harvest_job)
  end

  private

  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end

  def find_harvest_definition
    @harvest_definition = HarvestDefinition.find(params[:harvest_definition_id])
  end

  def harvest_job_params
    params.require(:harvest_job).permit(:extraction_job_id, :harvest_definition_id)
  end
end
