# frozen_string_literal: true

# Used to store information about a Harvest Job
class HarvestJob < ApplicationRecord
  include Job

  belongs_to :pipeline_job
  belongs_to :harvest_definition
  belongs_to :extraction_job, optional: true
  has_one    :harvest_report, dependent: :restrict_with_exception

  delegate :extraction_definition, to: :harvest_definition
  delegate :transformation_definition, to: :harvest_definition

  # This is to ensure that there is only ever one version of a HarvestJob running.
  # It is used when enqueing enrichments at the end of a harvest.
  validates :key, uniqueness: true

  after_create do
    self.name = "#{harvest_definition.name}__job-#{id}"
    save!
  end

  def cancel_sidekiq_workers!
    queue = Sidekiq::Queue.new

    queue.each do |job|
      job.delete if job.klass == 'TransformationWorker' && job.args[1] == id
      job.delete if job.klass == 'LoadWorker' && job.args[0] == id
    end
  end
end
