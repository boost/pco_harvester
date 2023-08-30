# frozen_string_literal: true

class PipelineJob < ApplicationRecord
  include Job

  serialize :harvest_definitions_to_run, Array

  belongs_to :pipeline
  belongs_to :extraction_job, optional: true
  belongs_to :destination

  has_many :harvest_reports

  enum :page_type, { all_available_pages: 0, set_number: 1 }

  validates :key, uniqueness: true
end
