# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PipelineJob do
  let(:destination)        { create(:destination) }

  describe 'associations' do
    it { is_expected.to have_many(:harvest_reports) }
  end

  describe '#validations' do
    subject                  { create(:pipeline_job, pipeline:, destination:) }

    let(:pipeline)           { create(:pipeline, name: 'NLNZCat') }
    let(:harvest_definition) { create(:harvest_definition, pipeline:) }

    it { is_expected.to validate_uniqueness_of(:key).case_insensitive.with_message('has already been taken') }

    it 'requires pages if the page_type is set_number' do
      job = build(:pipeline_job, pipeline:, destination:, page_type: 'set_number')

      expect(job).not_to be_valid
      expect(job.errors['pages']).to include "can't be blank"
    end

    it 'does not requires pages if the page_type is all_available_pages' do
      job = build(:pipeline_job, pipeline:, destination:, page_type: 'all_available_pages')

      expect(job).to be_valid
    end
  end

  describe '#execute_delete_previous_records' do
    let(:pipeline) { create(:pipeline, :figshare) }
    let(:harvest_definition) { pipeline.harvest }

    context 'when valid for deletion' do
      it 'tells the destination to delete previously harvested records' do
        pipeline_job = create(:pipeline_job, pipeline:, destination:, page_type: 'all_available_pages', harvest_definitions_to_run: [pipeline.harvest.id], delete_previous_records: true, status: 'completed')
        harvest_job = create(:harvest_job, :completed, harvest_definition:, pipeline_job:)
        harvest_report = create(:harvest_report, harvest_job:, records_loaded: 100, extraction_status: 'completed', transformation_status: 'completed', load_status: 'completed', delete_status: 'completed')
  
        expect(DeletePreviousRecords::Execution).to receive(:new).exactly(1).times
  
        pipeline_job.execute_delete_previous_records
      end
    end

    context 'when invalid for deletion' do
      it 'does not tell the destination to delete previously harvested records if it is not in the pipeline job settings' do
        pipeline_job = create(:pipeline_job, pipeline:, destination:, page_type: 'all_available_pages', harvest_definitions_to_run: [pipeline.harvest.id]) 
        harvest_job = create(:harvest_job, :completed, harvest_definition:, pipeline_job:)
        harvest_report = create(:harvest_report, harvest_job:, records_loaded: 10)
  
        expect(DeletePreviousRecords::Execution).to receive(:new).exactly(0).times
  
        pipeline_job.execute_delete_previous_records
      end

      it 'does not tell the destination to delete previously harvested records when there have been 0 records harvested' do
        pipeline_job = create(:pipeline_job, pipeline:, destination:, page_type: 'all_available_pages', harvest_definitions_to_run: [pipeline.harvest.id], delete_previous_records: true) 
        harvest_job = create(:harvest_job, :completed, harvest_definition:, pipeline_job:)
        harvest_report = create(:harvest_report, harvest_job:, records_loaded: 0)
  
        expect(DeletePreviousRecords::Execution).to receive(:new).exactly(0).times
  
        pipeline_job.execute_delete_previous_records
      end

      it 'does not tell the destination to delete previously harvested records when the harvest hasnt completed' do
        pipeline_job = create(:pipeline_job, pipeline:, destination:, page_type: 'all_available_pages', harvest_definitions_to_run: [pipeline.harvest.id], delete_previous_records: true) 
        harvest_job = create(:harvest_job, harvest_definition:, pipeline_job:)
        harvest_report = create(:harvest_report, harvest_job:, records_loaded: 10)
  
        expect(DeletePreviousRecords::Execution).to receive(:new).exactly(0).times
  
        pipeline_job.execute_delete_previous_records
      end

      it 'does not tell the destination to delete previously harvested records when the pipeline job has been cancelled' do
        pipeline_job = create(:pipeline_job, pipeline:, destination:, page_type: 'all_available_pages', harvest_definitions_to_run: [pipeline.harvest.id], delete_previous_records: true, status: 'cancelled') 
        harvest_job = create(:harvest_job, harvest_definition:, pipeline_job:)
        harvest_report = create(:harvest_report, :completed, harvest_job:, records_loaded: 10)
  
        expect(DeletePreviousRecords::Execution).to receive(:new).exactly(0).times
  
        pipeline_job.execute_delete_previous_records
      end
    end
  end
end
