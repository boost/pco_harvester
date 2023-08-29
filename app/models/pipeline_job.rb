# frozen_string_literal: true

class PipelineJob < ApplicationRecord
  has_many :pipeline_block_reports
end
