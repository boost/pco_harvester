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
  let(:field_with_error) { create(:field, transformation_definition:, block: 'result.title')}

  describe '#call' do
    it 'returns the result of applying the field to the record' do
      transformation = described_class.new([record], [field]).call.first.transformed_record

      expect(transformation['title']).to eq 'The title of the record'
    end

    it 'updates the error message on the field if an error has occured applying the field' do
      errors = described_class.new([record], [field_with_error]).call.first.errors

      expect(errors[field_with_error.id][:title]).to eq NameError
      expect(errors[field_with_error.id][:description]).to include "undefined local variable or method `result'"


    end
  end
end