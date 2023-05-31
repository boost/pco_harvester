# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe '#index' do
    it 'redirects to the content sources page' do
      get root_path
      expect(response).to redirect_to content_sources_path
    end
  end
end
