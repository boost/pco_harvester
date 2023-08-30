# frozen_string_literal: true

class PipelineJob < ApplicationRecord
  has_many :reports
end
