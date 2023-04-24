# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :find_content_partner, only: %i[show create]
  before_action :find_extraction_definition, only: %i[show create]
  before_action :find_job, only: %i[show]

  def index
    @jobs = Job.order(updated_at: :desc).page(params[:page])
  end

  def show; end

  def create
    @job = Job.new(extraction_definition: @extraction_definition)
    if @job.save
      ExtractionJob.perform_async(@job.id)
      flash.notice = 'Job queued successfuly'
    else
      flash.alert = 'There was an issue launching the job'
    end

    redirect_to content_partner_extraction_definition_path(@content_partner, @extraction_definition)
  end

  private

  def find_content_partner
    @content_partner = ContentPartner.find(params[:content_partner_id])
  end

  def find_extraction_definition
    @extraction_definition = ExtractionDefinition.find(params[:extraction_definition_id])
  end

  def find_job
    @job = Job.find(params[:id])
  end
end
