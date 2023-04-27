# frozen_string_literal: true

class JobsController < ApplicationController
  before_action :find_content_partner, only: %i[show create destroy cancel]
  before_action :find_extraction_definition, only: %i[show create destroy cancel]
  before_action :find_job, only: %i[show destroy cancel]

  def index
    @jobs = paginate_and_filter_jobs(Job)
  end

  def show
    @documents = @job.documents
    @document = @documents[params[:page]]
  end

  def create
    @job = Job.new(extraction_definition: @extraction_definition, kind: params[:kind])

    if @job.save
      ExtractionJob.perform_async(@job.id)
      flash.notice = 'Job queued successfuly'
    else
      flash.alert = 'There was an issue launching the job'
    end

    redirect_to content_partner_extraction_definition_path(@content_partner, @extraction_definition)
  end

  def destroy
    if @job.destroy
      flash.notice = 'Results deleted successfully'
      redirect_to content_partner_extraction_definition_path(@content_partner, @extraction_definition)
    else
      flash.alert = 'There was an issue deleting the results'
      redirect_to content_partner_extraction_definition_job_path(@content_partner, @extraction_definition, @job)
    end
  end

  def cancel
    if @job.mark_as_cancelled
      flash.notice = 'Job cancelled successfully'
    else
      flash.alert = 'There was an issue cancelling the job'
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
