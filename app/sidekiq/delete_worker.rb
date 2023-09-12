# frozen_string_literal: true

class DeleteWorker
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(records, destination_id, harvest_report_id)
    destination = Destination.find(destination_id)
    @harvest_report = HarvestReport.find(harvest_report_id)

    records_to_delete = JSON.parse(records)

    job_start

    records_to_delete.each do |record|
      Delete::Execution.new(record, destination).call
      @harvest_report.increment_records_deleted!
      @harvest_report.update(delete_updated_time: Time.zone.now)
    end

    job_end
  end

  def job_start
    @harvest_report.delete_running!
  end

  def job_end
    @harvest_report.increment_delete_workers_completed!

    return unless @harvest_report.delete_workers_completed?

    @harvest_report.delete_completed!
  end
end
