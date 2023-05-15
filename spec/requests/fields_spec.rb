# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Fields", type: :request do
  let(:content_partner) { create(:content_partner) }
  let(:extraction_job)             { create(:extraction_job) }
  let!(:transformation_definition)  { create(:transformation_definition, content_partner:, extraction_job:) }

  describe '#create' do
    let(:field)           { build(:field, transformation_definition:) }

    context 'with valid parameters' do
      it 'creates a new field' do
        expect do
          post content_partner_transformation_definition_fields_path(content_partner, transformation_definition), params: {
            field: field.attributes
          }
        end.to change(Field, :count).by(1)
      end

      it 'returns a JSON object representing the new field' do
        post content_partner_transformation_definition_fields_path(content_partner, transformation_definition), params: {
          field: field.attributes
        }

        field = JSON.parse(response.body)

        expect(field['name']).to eq 'title'
        expect(field['block']).to eq "JsonPath.new('title').on(record).first"

      end
    end
  end

  describe '#update' do
    let(:field) { create(:field, transformation_definition:) }

    context 'with valid parameters' do
      it 'updates the field' do
        patch content_partner_transformation_definition_field_path(content_partner, transformation_definition, field), params: {
          field: { name: 'Description' }
        }

        field.reload

        expect(field.name).to eq 'Description'
      end

      it 'returns a JSON hash of the updated field' do
        patch content_partner_transformation_definition_field_path(content_partner, transformation_definition, field), params: {
          field: { name: 'Description' }
        }

        expect(JSON.parse(response.body)['name']).to eq 'Description'
      end
    end
  end

  describe '#destroy' do
    let!(:field) { create(:field, transformation_definition:) }

    it 'deletes the field' do
      expect { delete content_partner_transformation_definition_field_path(content_partner, transformation_definition, field) }.to change(Field, :count).by(-1)
    end

    it 'returns a successful response' do
      delete content_partner_transformation_definition_field_path(content_partner, transformation_definition, field)

      expect(response.status).to eq(200)
    end
  end


  describe "#run" do
    context 'with a valid fields' do

      let!(:field_one)   { create(:field, name: 'title', block: "JsonPath.new('title').on(record).first", transformation_definition: transformation_definition) }
      let!(:field_two)   { create(:field, name: 'source', block: "JsonPath.new('source').on(record).first", transformation_definition: transformation_definition) }
      let!(:field_three) { create(:field, name: 'dc_identifier', block: "JsonPath.new('reference_number').on(record).first", transformation_definition: transformation_definition) }
      let!(:field_four) { create(:field, name: 'landing_url', block: '"http://www.ngataonga.org.nz/collections/catalogue/catalogue-item?record_id=#{record[\'record_id\']}"', transformation_definition: transformation_definition) }

      it 'returns a new record made up of the given transformation fields' do
        post run_content_partner_transformation_definition_fields_path(content_partner, transformation_definition), params: {
          record: {
            title: 'title',
            source: 'source',
            reference_number: '111',
            record_id: '128'
          },
          fields: [field_one.id, field_two.id, field_three.id, field_four.id]
        }

        transformed_record = JSON.parse(response.body)['transformed_record']

        expect(transformed_record['title']).to eq 'title'
        expect(transformed_record['source']).to eq 'source'
        expect(transformed_record['dc_identifier']).to eq '111'
        expect(transformed_record['landing_url']).to eq 'http://www.ngataonga.org.nz/collections/catalogue/catalogue-item?record_id=128'
      end
    end

    context 'with invalid transformations' do
      it 'returns the errors from the given transformation fields' do
        pending 'not yet implemented'
        raise
      end
    end
  end
end
