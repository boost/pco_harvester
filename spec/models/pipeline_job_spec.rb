# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PipelineJob, type: :model do
  it { is_expected.to have_many(:pipeline_block_reports) }
end
