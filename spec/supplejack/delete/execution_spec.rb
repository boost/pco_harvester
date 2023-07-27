# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Delete::Execution do
  let(:record) do
    {
      transformed_record: {
        internal_identifier: 'abc'
      }
    }
  end
  
  let(:pipeline)    { create(:pipeline, name: 'test') }
  let(:destination) { create(:destination) }

  describe '#call' do
    it 'sends the internal identifier to the API to be deleted' do

    end
  end
end
