# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extraction::Execution do
  let(:full_job)                      { create(:extraction_job, extraction_definition:) }
  let(:sample_job)                    { create(:extraction_job, kind: 'sample', extraction_definition:) }
  let(:extraction_definition)         { create(:extraction_definition, :figshare) }
  let(:request_one)                   { create(:request, :figshare_initial_request, extraction_definition:) }
  let(:request_two)                   { create(:request, :figshare_main_request, extraction_definition:) }

  before do
    stub_figshare_harvest_requests(request_one)
    stub_figshare_harvest_requests(request_two)
  end

  describe '#call' do
    context 'when running a full job' do
      let(:subject) { described_class.new(full_job, extraction_definition) }

      it 'saves the full response from the content source to the filesystem' do
        subject.call

        expect(File.exist?(full_job.extraction_folder)).to eq true
        extracted_files = Dir.glob("#{full_job.extraction_folder}/*").select { |e| File.file? e }

        expect(extracted_files.count).to eq 5
      end
    end

    context 'when running a sample job' do
      let(:subject) { described_class.new(sample_job, extraction_definition) }

      it 'saves the first page from the content source to the filesystem' do
        subject.call

        expect(File.exist?(sample_job.extraction_folder)).to eq true
        extracted_files = Dir.glob("#{sample_job.extraction_folder}/*").select { |e| File.file? e }

        expect(extracted_files.count).to eq 1
      end
    end

    context 'when the extraction definition has a throttle' do
      let(:extraction_job) { create(:extraction_job) }
      let(:extraction_definition) { create(:extraction_definition, :figshare, extraction_jobs: [extraction_job]) }
      let(:subject) { described_class.new(extraction_job, extraction_definition) }

      it 'respects the throttle set in the extraction_definition' do
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        subject.call

        end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        total_time = end_time - start_time

        expect(total_time.ceil).to eq 5
      end
    end

    context 'when the job has been cancelled' do
      let(:extraction_job) { create(:extraction_job, status: 'cancelled') }
      let(:extraction_definition) { create(:extraction_definition, :figshare, throttle: 500, extraction_jobs: [extraction_job]) }
      let(:subject) { described_class.new(extraction_job, extraction_definition) }

      it 'does not extract further pages' do
        subject.call

        expect(File.exist?(extraction_job.extraction_folder)).to eq true
        extracted_files = Dir.glob("#{extraction_job.extraction_folder}/*").select { |e| File.file? e }

        expect(extracted_files.count).to eq 2
      end
    end

    context 'when the job is part of a harvest' do
      let(:ej) { create(:extraction_job) }
      let(:sample_ej) { create(:extraction_job, :sample) }
      let(:ed) { create(:extraction_definition, :figshare) }
      let(:pipeline) { create(:pipeline) }
      let(:harvest_definition) { create(:harvest_definition, pipeline:) }
      let(:destination) { create(:destination) }
      let!(:hj) { create(:harvest_job, extraction_job: ej, harvest_definition:, destination:) }
      let!(:sample_hj) { create(:harvest_job, extraction_job: sample_ej, harvest_definition:, destination:) }

      before do
        stub_figshare_harvest_requests(ed)
      end

      context 'when it is a full harvest' do
        let(:subject) { described_class.new(ej, ed) }

        it 'creates TransformationJobs for each page' do
          expect { subject.call }.to change(TransformationJob, :count).by(5)
          expect(TransformationJob.last(5).map(&:page)).to eq [1, 2, 3, 4, 5]
        end

        it 'enqueues 5 TransformationWorkers in sidekiq' do
          expect(TransformationWorker).to receive(:perform_async).exactly(5).times.and_call_original

          subject.call
        end
      end

      context 'when it is a sample harvest' do
        let(:subject) { described_class.new(sample_ej, ed) }

        it 'creates TransformationJobs for the first page' do
          expect { subject.call }.to change(TransformationJob, :count).by(1)
          expect(TransformationJob.last(1).map(&:page)).to eq [1]
        end

        it 'enqueues 1 TransformationWorker in sidekiq' do
          expect(TransformationWorker).to receive(:perform_async).once.and_call_original

          subject.call
        end
      end

      context 'when the document has failed to be extracted' do
        before do
          stub_failed_figshare_harvest_requests(ed)
        end

        let(:subject) { described_class.new(ej, ed) }

        it 'does not create TransformationJobs for failed pages' do
          expect { subject.call }.not_to change(TransformationJob, :count)
        end

        it 'enqueues 0 TransformationWorkers in sidekiq' do
          expect(TransformationWorker).to receive(:perform_async).exactly(0).times.and_call_original

          subject.call
        end
      end

      context 'when the extraction_definition format is JSON' do
        let(:subject) { described_class.new(ej, ed) }

        context 'when the extraction_definition pagination_type is token' do
          let(:ed) do
            create(:extraction_definition, format: 'JSON', pagination_type: 'tokenised', total_selector: '$.total_results',
                                           page: 1, per_page_parameter: 'per_page', per_page: 30, token_parameter: 'id_above', token_value: '0', next_token_path: '$.results[(@.length-1)].id')
          end

          before do
            stub_inaturalist_harvest_requests(ed,
                                              {
                                                1 => '0',
                                                2 => '2098031',
                                                3 => '4218778',
                                                4 => '7179629'
                                              })
          end

          it 'creates TransformationJobs for each page' do
            expect { subject.call }.to change(TransformationJob, :count).by(4)
            expect(TransformationJob.last(4).map(&:page)).to eq [1, 2, 3, 4]
          end

          it 'enqueues 4 TransformationWorkers in sidekiq' do
            expect(TransformationWorker).to receive(:perform_async).exactly(4).times.and_call_original

            subject.call
          end
        end
      end

      context 'when the extraction_definition format is XML' do
        let(:subject) { described_class.new(ej, ed) }

        context 'when the extraction_definition pagination_type is page' do
          let(:ed) do
            create(:extraction_definition, format: 'XML', pagination_type: 'page', total_selector: '//count/text()',
                                           page_parameter: 'page', page: 1, per_page_parameter: 'page_size', per_page: 50)
          end

          before do
            stub_freesound_harvest_requests(ed)
          end

          it 'creates TransformationJobs for each page' do
            expect { subject.call }.to change(TransformationJob, :count).by(4)
            expect(TransformationJob.last(4).map(&:page)).to eq [1, 2, 3, 4]
          end

          it 'enqueues 4 TransformationWorkers in sidekiq' do
            expect(TransformationWorker).to receive(:perform_async).exactly(4).times.and_call_original

            subject.call
          end
        end

        context 'when the extraction_definition pagination_type is tokenised' do
          let(:ed) do
            create(:extraction_definition, format: 'XML', pagination_type: 'tokenised', total_selector: '//records/@total',
                                           page: 1, per_page_parameter: 'n', per_page: 100, token_parameter: 's', token_value: '*', next_token_path: '//records/@nextStart')
          end

          before do
            stub_trove_harvest_requests(ed,
                                        {
                                          1 => '*',
                                          2 => 'AoErc3UyMzQwNjY5OTI=',
                                          3 => 'AoErc3UyMzQwNjcwOTI=',
                                          4 => 'AoErc3UyMzQwNjcxOTQ='
                                        })
          end

          it 'creates TransformationJobs for each page' do
            expect { subject.call }.to change(TransformationJob, :count).by(4)
            expect(TransformationJob.last(4).map(&:page)).to eq [1, 2, 3, 4]
          end

          it 'enqueues 4 TransformationWorkers in sidekiq' do
            expect(TransformationWorker).to receive(:perform_async).exactly(4).times.and_call_original

            subject.call
          end
        end
      end
    end
  end
end
