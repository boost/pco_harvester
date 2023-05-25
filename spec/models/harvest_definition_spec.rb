# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HarvestDefinition, type: :model do
  subject do
    create(
      :harvest_definition,
      content_partner:,
      extraction_definition:,
      transformation_definition:,
      destination:
    )
  end

  let(:content_partner) { create(:content_partner, :ngataonga, name: 'National Library of New Zealand') }
  let(:extraction_definition) { content_partner.extraction_definitions.first }
  let(:extraction_job) { create(:extraction_job, extraction_definition:) }
  let(:transformation_definition) { create(:transformation_definition, content_partner:, extraction_job:) }
  let(:destination) { create(:destination) }

  describe '#attributes' do
    it 'belongs to a content partner' do
      expect(subject.content_partner).to eq content_partner
    end

    it 'has a copy of the provided extraction definition' do
      expect(subject.extraction_definition.original_extraction_definition).to eq extraction_definition
    end

    it 'has a transformation definition' do
      expect(subject.transformation_definition.original_transformation_definition).to eq transformation_definition
    end

    it 'has a destination' do
      expect(subject.destination).to eq destination
    end
  end

  describe '#clone_transformation_definition' do
    let(:field) { build(:field) }
    let!(:transformation_definition) { create(:transformation_definition, fields: [field]) }

    it 'creates a safe copy of the provided transformation definition' do
      expect {
        described_class.new(transformation_definition:).clone_transformation_definition
      }.to change(TransformationDefinition, :count).by(1)
    end

    it 'creates a copy of the transformation definition that has the same fields' do
      described_class.new(transformation_definition:).clone_transformation_definition

      expect(transformation_definition.copies.count).to eq 1
      copy = transformation_definition.copies.first
      expect(copy.original_transformation_definition).to eq transformation_definition

      transformation_definition.fields.zip(copy.fields) do |transformation_definition_field, copy_field|
        expect(copy_field.name).to eq transformation_definition_field.name
        expect(copy_field.block).to eq transformation_definition_field.block
      end  
    end
  end

  describe '#update_transformation_definition_clone' do
    let(:field) { build(:field) }
    let(:transformation_definition) { create(:transformation_definition, content_partner:, extraction_job:, fields: [field]) }

    let(:updated_field) { build(:field, name: 'test') }
    let(:updated_transformation_definition) { create(:transformation_definition, content_partner:, extraction_job:, name: 'updated', record_selector: 'updated record selector', fields: [updated_field]) }
    let(:harvest_job) { create(:harvest_job, harvest_definition: subject) }

    it 'updates the safe transformation definition copy to have the new fields and record_selector' do
      subject
      copy = transformation_definition.copies.first
      expect(subject.transformation_definition).to eq transformation_definition.copies.first
      subject.update_transformation_definition_clone(updated_transformation_definition)

      subject.reload

      expect(subject.transformation_definition.record_selector).to eq 'updated record selector'
      expect(subject.transformation_definition.fields.first.name).to eq 'test'
    end

    it 'maintains the relationship between the copied transformation definition and anything else that references it' do
      subject
      copy = transformation_definition.copies.first
      expect(subject.transformation_definition).to eq transformation_definition.copies.first
      subject.update_transformation_definition_clone(updated_transformation_definition)

      subject.reload

      expect(subject.transformation_definition.id).to eq copy.id
    end
  end

  describe '#clone_extraction_definition' do
    let!(:extraction_definition) { create(:extraction_definition) }

    it 'creates a safe copy of the extraction_definition' do
      expect {
        described_class.new(extraction_definition:).clone_extraction_definition
      }.to change(ExtractionDefinition, :count).by(1)
    end

    it 'creates a safe copy of the extraction definition that has the same information' do
      described_class.new(extraction_definition:).clone_extraction_definition
      
      expect(extraction_definition.copies.count).to eq 1
      copy = extraction_definition.copies.first
      expect(copy.original_extraction_definition).to eq extraction_definition
    end
  end

  describe '#update_extraction_definition_clone' do
    let!(:extraction_definition) { create(:extraction_definition) }
    let!(:updated_extraction_definition) { create(:extraction_definition, base_url: 'http://www.test.co.nz') }

    it 'updates the extraction_definition clone to have the same values as the provided extracted_definition' do
      subject
      copy = extraction_definition.copies.first
      expect(subject.extraction_definition).to eq extraction_definition.copies.first
      subject.update_extraction_definition_clone(updated_extraction_definition)

      subject.reload

      expect(subject.extraction_definition.base_url).to eq 'http://www.test.co.nz'
    end

    it 'maintains the relationship between the extraction_definition and anything else that references it' do
      subject
      copy = extraction_definition.copies.first
      expect(subject.extraction_definition).to eq extraction_definition.copies.first
      subject.update_extraction_definition_clone(updated_extraction_definition)

      subject.reload

      expect(subject.extraction_definition.id).to eq copy.id
    end
  end

  describe '#name' do
    it 'automatically generates a sensible name' do
      expect(subject.name).to eq "national-library-of-new-zealand__harvest-definition__#{subject.id}"
    end
  end
end
