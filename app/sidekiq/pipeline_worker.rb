# frozen_string_literal: true

class PipelineWorker < ApplicationWorker
  def child_perform(pipeline_job)
    @pipeline_job = pipeline_job
    @pipeline = pipeline_job.pipeline

    [@pipeline.harvest, @pipeline.enrichments].flatten.each do |definition|
      next if definition.nil?
      next unless should_queue_harvest_job?(definition.id)

      # TODO: potentially this should be created earlier.
      HarvestReport.create(pipeline_job: @pipeline_job, harvest_definition: definition)

      # job_params = harvest_job_params.to_h

      # job_params[:harvest_definition_id] = definition.id
      # job_params[:key] = "#{harvest_job_params['key']}__enrichment-#{definition.id}" if definition.enrichment?
      # job = HarvestJob.new(job_params)

      # if job.save
      #   HarvestWorker.perform_async(job.id)
      #   flash.notice = 'Job queued successfully'
      # else
      #   flash.alert = 'There was an issue queueing your job'
      # end

      # If the user has scheduled a harvest we do not need to enqueue the enrichments now
      # as they will be enqueued once the harvest job has finished.
      # break if definition.harvest?
    end
  end

  def should_queue_harvest_job?(id)
    return false if @pipeline_job.harvest_definitions_to_run.nil?

    @pipeline_job.harvest_definitions_to_run.map(&:to_i).include?(id)
  end
end