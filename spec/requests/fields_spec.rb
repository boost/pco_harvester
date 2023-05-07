# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Fields", type: :request do
  let(:content_partner) { create(:content_partner) }
  let(:job)             { create(:job) }
  let!(:transformation_definition)  { create(:transformation_definition, content_partner:, job:) }

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

        expect(field['name']).to eq 'Title'
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
end
