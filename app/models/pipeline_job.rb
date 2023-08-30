# frozen_string_literal: true

class PipelineJob < ApplicationRecord
  has_many :harvest_reports
end
