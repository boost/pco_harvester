# frozen_string_literal: true

require 'rails_helper' 

RSpec.describe Transformation::Execution do
  let(:content_partner) { create(:content_partner, :ngataonga) } 
  let(:extraction_definition) { content_partner.extraction_definitions.first }
  let(:job)             { create(:job, extraction_definition:) } 
  let(:transformation_definition) { create(:transformation_definition, content_partner:, job:) }

  let(:record) {
    {
      'record_id' => 1123,
      'title' => 'The title of the record',
      'description' => 'The description of the record'
    }
  }
  let(:field) { create(:field, transformation_definition:) }
  let(:field_with_error) { create(:field, transformation_definition:, block: 'Error')}

  describe '#call' do
    it 'returns the result of applying the field to the record' do
      expect(described_class.new(record, field).call).to eq 'The title of the record'
    end

    it 'updates the error message on the field if an error has occured applying the field' do
      described_class.new(record, field_with_error).call
      field_with_error.reload
      expect(field_with_error.error).to eq 'uninitialized constant Transformation::Execution::Error'
    end
  end
end
