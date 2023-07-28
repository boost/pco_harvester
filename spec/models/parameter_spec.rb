# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Parameter, type: :model do
  describe 'validations' do
    subject { build(:parameter) }

    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_presence_of(:value) }
  end
  
  describe 'associations' do
    it { is_expected.to belong_to(:request) }
  end
end
