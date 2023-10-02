# frozen_string_literal: true

class ScheduleWorker
  include Sidekiq::Job

  def perform(id)
    schedule = Schedule.find(id)

    job = PipelineJob.create(
      pipeline_id: schedule.pipeline.id,
      harvest_definitions_to_run: schedule.harvest_definitions_to_run,
      destination_id: schedule.destination.id,
      key: SecureRandom.hex,
      page_type: :all_available_pages,
      schedule_id: id
    )

    PipelineWorker.perform_async(job.id)
  end
end
