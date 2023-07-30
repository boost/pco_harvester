# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadJob, type: :model do
  let(:pipeline)           { create(:pipeline, name: 'National Library of New Zealand') }
  let(:harvest_definition) { create(:harvest_definition, pipeline:) }
  let(:destination)        { create(:destination) }
  let(:harvest_job)        { create(:harvest_job, :completed, harvest_definition:, destination:) }
  let(:load_job)           { create(:load_job, harvest_job:) }

  describe '#name' do
    it 'automatically generates a sensible name' do
      expect(load_job.name).to eq "#{harvest_definition.name}__load-job-#{load_job.id}"
    end
  end
end
