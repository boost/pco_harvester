require 'rails_helper'

RSpec.describe "Pipelines", type: :request do
  let(:user) { create(:user) }
  let!(:pipeline) { create(:pipeline, name: 'DigitalNZ Production') }

  before do
    sign_in(user)
  end

  describe "GET /index" do
    it 'displays a list of pipelines' do
      get pipelines_path

      expect(response.status).to eq 200
      expect(response.body).to include CGI.escapeHTML(pipeline.name)
    end
  end
end
