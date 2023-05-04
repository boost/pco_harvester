# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Fields", type: :request do
  let(:content_partner) { create(:content_partner) }
  let(:job)             { create(:job) }
  let(:transformation)  { create(:transformation, content_partner:, job:) }

  describe '#create' do
    let(:field)           { build(:field, transformation:) }

    context 'with valid parameters' do
      it 'creates a new field' do 
        expect do
          post content_partner_transformation_fields_path(content_partner, transformation), params: {
            field: field.attributes
          }
        end.to change(Field, :count).by(1)
      end

      it 'returns a JSON object representing the new field' do
        post content_partner_transformation_fields_path(content_partner, transformation), params: {
          field: field.attributes
        }

        field = JSON.parse(response.body)

        expect(field['name']).to eq 'Title'
        expect(field['block']).to eq "JsonPath.new('title').on(record).first"
     
      end
    end
  end
end
