# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransformationJob, type: :model do
  let(:content_partner) { create(:content_partner, name: 'National Library of New Zealand') }
  let(:extraction_job) { create(:extraction_job) }
  let(:transformation_definition) { create(:transformation_definition, content_partner:) }
  let(:subject) { create(:transformation_job, extraction_job:, transformation_definition:) }

  describe '#name' do
    it 'automatically generates a sensible name' do
      expect(subject.name).to eq "#{transformation_definition.name}__job-#{subject.id}"
    end
  end
end
