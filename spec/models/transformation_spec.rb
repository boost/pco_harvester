require 'rails_helper'

RSpec.describe Transformation, type: :model do
  let(:content_partner) { create(:content_partner) } 
  let(:job)             { create(:job) } 
  let(:subject)         { create(:transformation, content_partner: content_partner, job: job) }
  
  describe '#attributes' do
    it 'has a name' do
      expect(subject.name).to eq 'Name'
    end

    it 'has a record selector' do
      expect(subject.record_selector).to eq '$..results'
    end

    it 'belongs to a content partner' do
      expect(subject.content_partner).to eq content_partner
    end

    it 'has a job' do
      expect(subject.job).to eq job
   end
  end
end
