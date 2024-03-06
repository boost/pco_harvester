# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextExtractionWorker, type: :job do
  let(:pipeline) { create(:pipeline, name: 'PDF Example') }
  let(:extraction_definition) { create(:extraction_definition, pipeline:, format: 'JSON', extract_text_from_file: true) }
  let(:extraction_job) { create(:extraction_job, extraction_definition:) }

  describe "#perform" do
    before do
      FileUtils.cp("#{Rails.root}/spec/support/example.pdf", "#{extraction_job.extraction_folder}/example.pdf")
    end

    it 'converts a PDF into raw text' do
      extracted_files = Dir.glob("#{extraction_job.extraction_folder}/*").select { |e| File.file? e }
  
      expect(extracted_files.count).to eq 1

      TextExtractionWorker.new.perform(extraction_job.id)

      extracted_files = Dir.glob("#{extraction_job.extraction_folder}/*").select { |e| File.file? e }
  
      expect(extracted_files.count).to eq 1
    end

    it 'cleans up the tmp folder it creates' do
      expect(Dir.exist?("#{extraction_job.extraction_folder}/tmp")).to eq false

      TextExtractionWorker.new.perform(extraction_job.id)

      expect(Dir.exist?("#{extraction_job.extraction_folder}/tmp")).to eq false 
    end

    it 'names the new files following the appropriate naming convention' do
      TextExtractionWorker.new.perform(extraction_job.id)
      
      expect(File.exist?("#{extraction_job.extraction_folder}/pdf-example_harvest-extraction-210__-__000000001.json"))
    end

    context 'when the PDF extraction is not part of a harvest' do
      before do
        FileUtils.cp("#{Rails.root}/spec/support/example.pdf", "#{extraction_job.extraction_folder}/example.pdf")
      end

      it 'does not enqueue Transformation Workers' do
        expect(TransformationWorker).not_to receive(:perform_async)

        TextExtractionWorker.new.perform(extraction_job.id) 
      end
    end

    context 'when the PDF extraction is part of a harvest' do
      before do
        FileUtils.cp("#{Rails.root}/spec/support/example.pdf", "#{extraction_job.extraction_folder}/example.pdf")
      end
      
      let!(:harvest_report)    { create(:harvest_report, pipeline_job:, harvest_job:) }
      let(:destination)        { create(:destination) }
      let(:pipeline_job)       { create(:pipeline_job, pipeline:, destination:) }
      let(:harvest_definition) { create(:harvest_definition, pipeline:) }
      let(:harvest_job)        { create(:harvest_job, harvest_definition:, pipeline_job:) }
      let(:extraction_job)     { create(:extraction_job, extraction_definition:, harvest_job:) }
      
      it 'enqueues Transformation Workers to process the text from the PDF' do
        expect(TransformationWorker).to receive(:perform_async).exactly(1).times.and_call_original

        TextExtractionWorker.new.perform(extraction_job.id) 
      end
      
      it 'updates the Harvest Report appropriately' do
        expect(harvest_report.pages_extracted).to eq 0

        TextExtractionWorker.new.perform(extraction_job.id)  

        harvest_report.reload

        expect(harvest_report.pages_extracted).to eq 1
        expect(harvest_report.transformation_workers_queued).to eq 1
      end
    end
  end
end
