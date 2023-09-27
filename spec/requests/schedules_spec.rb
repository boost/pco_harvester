require 'rails_helper'

RSpec.describe "Schedules", type: :request do
  let(:pipeline) { create(:pipeline) }
  let(:user)     { create(:user) }

  before do
    sign_in(user)
  end

  describe "GET /index" do
    it 'returns a successful response' do
      get pipeline_schedules_path(pipeline)
      
      expect(response).to have_http_status :ok
    end
  end
end
