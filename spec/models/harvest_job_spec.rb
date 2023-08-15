# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HarvestJob, type: :model do
  let(:destination)        { create(:destination) }
  let(:pipeline)           { create(:pipeline, name: 'NLNZCat') }
  let(:harvest_definition) { create(:harvest_definition, pipeline:) }
  let(:harvest_job)        { create(:harvest_job, :completed, harvest_definition:, destination:) }

  describe '#duration_seconds' do
    it 'returns nil if extraction_job is nil' do
      harvest_job.extraction_job = nil
      expect(harvest_job.duration_seconds).to be_nil
    end

    it 'returns nil if load_jobs is empty' do
      harvest_job.load_jobs = []
      expect(harvest_job.duration_seconds).to be_nil
    end

    it 'returns nil if no load jobs have an end_time' do
      harvest_job.load_jobs.update(end_time: nil)
      expect(harvest_job.duration_seconds).to be_nil
    end

    it 'returns nil if extraction_job has no start_time' do
      harvest_job.extraction_job.update(start_time: nil)
      expect(harvest_job.duration_seconds).to be_nil
    end

    it 'returns the number of seconds between the extraction start_time ignoring idle time between jobs and the max load_job end_time' do
      expect(harvest_job.duration_seconds).to eq 3_960.0
    end
  end

  describe '#transformation_and_load_duration_seconds' do
    it 'returns nil if transformation jobs is empty' do
      harvest_job.transformation_jobs = []
      expect(harvest_job.transformation_and_load_duration_seconds).to be_nil
    end

    it 'returns nil if load_jobs is empty' do
      harvest_job.load_jobs = []
      expect(harvest_job.transformation_and_load_duration_seconds).to be_nil
    end

    it 'returns nil if no load jobs have an end_time' do
      harvest_job.load_jobs.update(end_time: nil)
      expect(harvest_job.transformation_and_load_duration_seconds).to be_nil
    end

    it 'returns nil if transformation jobs have no start_time' do
      harvest_job.transformation_jobs.update(start_time: nil, end_time: nil)
      expect(harvest_job.transformation_and_load_duration_seconds).to be_nil
    end

    it 'returns the number of seconds between the extraction start_time and the max load_job end_time' do
      expect(harvest_job.transformation_and_load_duration_seconds).to eq 360.0
    end
  end

  describe '#name' do
    it 'automatically generates a sensible name' do
      expect(harvest_job.name).to eq "#{harvest_job.harvest_definition.name}__job-#{harvest_job.id}"
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:destination) }
  end

  describe '#validations' do
    subject                  { create(:harvest_job, harvest_definition:, destination:) }

    let(:pipeline)           { create(:pipeline, name: 'NLNZCat') }
    let(:destination)        { create(:destination) }
    let(:harvest_definition) { create(:harvest_definition, pipeline:) }

    it { is_expected.to validate_uniqueness_of(:key).case_insensitive.with_message('has already been taken') }

    it 'requires pages if the page_type is custom' do
      job = build(:harvest_job, harvest_definition:, destination:, page_type: 'custom')

      expect(job).not_to be_valid
      expect(job.errors['pages']).to include "can't be blank"
    end

    it 'does not requires pages if the page_type is all' do
      job = build(:harvest_job, harvest_definition:, destination:, page_type: 'all_pages')

      expect(job).to be_valid
    end
  end

  describe '#completed?' do
    it 'returns true when extraction, transformation, and load jobs have finished' do
      expect(harvest_job.completed?).to eq true
    end

    context 'when a harvest is still running' do
      it 'returns false when an extraction is still running' do
        incomplete_harvest_job = create(:harvest_job, :completed, harvest_definition:, destination:)

        incomplete_harvest_job.extraction_job.update(status: 'running')

        incomplete_harvest_job.reload
        expect(incomplete_harvest_job.completed?).to eq false
      end

      it 'returns false when a transformation is still running' do
        incomplete_harvest_job = create(:harvest_job, :completed, harvest_definition:, destination:)

        incomplete_harvest_job.transformation_jobs.first.update(status: 'running')

        incomplete_harvest_job.reload
        expect(incomplete_harvest_job.completed?).to eq false
      end

      it 'returns false when a load is still running' do
        incomplete_harvest_job = create(:harvest_job, :completed, harvest_definition:, destination:)

        incomplete_harvest_job.load_jobs.first.update(status: 'running')

        incomplete_harvest_job.reload
        expect(incomplete_harvest_job.completed?).to eq false
      end
    end
  end

  describe '#page_type' do
    it 'can be all' do
      expect(create(:harvest_job, harvest_definition:, destination:,  page_type: 0).all_pages?).to eq true
    end

    it 'can be custom' do
      expect(create(:harvest_job, harvest_definition:, destination:, page_type: 1, pages: 10).custom?).to eq true
    end
  end  

  describe '#should_run?' do
    let(:pipeline) { create(:pipeline) }
    let!(:harvest_definition) { create(:harvest_definition, pipeline:) }
    let!(:enrichment_definition_one) { create(:harvest_definition, :enrichment, pipeline:) }
    let!(:enrichment_definition_two) { create(:harvest_definition, :enrichment, pipeline:) }
    let(:harvest_job)                { create(:harvest_job, harvest_definitions_to_run: [harvest_definition.id, enrichment_definition_one.id], harvest_definition:, destination:) }
    let(:no_harvest_job)             { create(:harvest_job, harvest_definitions_to_run: [enrichment_definition_two.id], harvest_definition:, destination:) }

    it 'returns true if the provided id is included in the harvest_definitions_to_run attribute' do
      expect(harvest_job.should_run?(harvest_definition.id)).to eq true
    end

    it 'returns false if the provided id is not included in the harvest job' do
      expect(no_harvest_job.should_run?(enrichment_definition_one.id)).to eq false
    end
  end
end
