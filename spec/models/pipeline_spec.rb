require 'rails_helper'

RSpec.describe Pipeline, type: :model do
  describe '#validations' do
    subject { build(:pipeline) }
    
    it { is_expected.to validate_presence_of(:name) }
  end
end
