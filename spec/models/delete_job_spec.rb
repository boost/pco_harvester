require 'rails_helper'

RSpec.describe DeleteJob, type: :model do
  let(:pipeline)           { create(:pipeline, name: 'National Library of New Zealand') }
  let(:harvest_definition) { create(:harvest_definition, pipeline:) }
  let(:destination)        { create(:destination) }
  let(:harvest_job)        { create(:harvest_job, :completed, harvest_definition:, destination:) }
  let(:delete_job)         { create(:delete_job, harvest_job:) }

  describe '#name' do
    it 'automatically generates a sensible name' do
      expect(delete_job.name).to eq "#{harvest_definition.name}__delete-job-#{delete_job.id}"
    end
  end
end
