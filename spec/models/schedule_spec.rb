require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:pipeline) }
    it { is_expected.to belong_to(:destination) }
  end
end
