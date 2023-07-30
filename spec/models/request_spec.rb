# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Request do
  describe 'associations' do
    it { is_expected.to belong_to(:extraction_definition) }
    it { is_expected.to have_many(:parameters) }
  end
end
