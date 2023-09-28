# frozen_string_literal: true

class ScheduleWorker
  include Sidekiq::Job

  def perform(args)
    job = PipelineJob.create(
      pipeline_id: args['pipeline_id'],
      harvest_definitions_to_run: args['harvest_definitions_to_run'],
      destination_id: args['destination_id'],
      key: SecureRandom.hex,
      page_type: :all_available_pages
    )

    PipelineWorker.perform_async(job.id)
  end
end

