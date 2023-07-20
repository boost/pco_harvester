# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoadWorker, type: :job do
  let!(:pipeline)              { create(:pipeline, :ngataonga) }
  let!(:harvest_definition)    { pipeline.harvest }
  let!(:enrichment_definition) { create(:harvest_definition, kind: 'enrichment', pipeline:) }
  let(:destination)            { create(:destination) }

  describe '#perform' do
    let(:harvest_job)            { create(:harvest_job, :completed, harvest_definition:, destination:, key: 'test') }
    let!(:load_job)              { create(:load_job, harvest_job:) }

    context 'when the harvest has completed' do
      it 'queues enrichments that are ready to be run' do
        expect(HarvestWorker).to receive(:perform_async)

        expect do
          LoadWorker.new.perform(load_job.id, '[]')
        end.to change(HarvestJob, :count).by(1)
      end

      it 'does not queue enrichments if there is allready an existing enrichment with the same key' do
        enrichment_job = create(:harvest_job, :completed, harvest_definition: enrichment_definition, destination:, key: "test__enrichment-#{enrichment_definition.id}")
        enrichment_load_job = create(:load_job, harvest_job: enrichment_job)
        
        HarvestJob.create(
          harvest_definition: enrichment_definition,
          destination_id: destination.id,
          key: "#{enrichment_job.key}__enrichment-#{enrichment_definition.id}"
        )
        
        expect do
          LoadWorker.new.perform(enrichment_load_job.id, '[]')
        end.to change(HarvestJob, :count).by(0)
      end
    end

    context 'when the harvest is not completed' do
      let(:harvest_job)            { create(:harvest_job, harvest_definition:, destination:, key: 'test') }
      let!(:load_job)              { create(:load_job, harvest_job:) }

      it 'does not queue enrichments' do
        expect(HarvestWorker).not_to receive(:perform_async)

        expect do
          LoadWorker.new.perform(load_job.id, '[]')
        end.to change(HarvestJob, :count).by(0)
      end
    end
  end
end
