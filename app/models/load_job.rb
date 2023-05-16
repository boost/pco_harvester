# frozen_string_literal: true

class LoadJob < ApplicationRecord
  include Job

  belongs_to :harvest_job
end
