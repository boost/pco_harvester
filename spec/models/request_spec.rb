# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Request do
  describe 'validations' do
    subject { build(:request) }
    
    it { is_expected.to validate_presence_of(:kind) }
  end
  
  describe 'associations' do
    it { is_expected.to belong_to(:extraction_definition) }
  end
end
