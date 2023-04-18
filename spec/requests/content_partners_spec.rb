require 'rails_helper'

RSpec.describe "ContentPartners", type: :request do
  describe "GET /index" do
    it 'renders the :index template' do
      get '/content_partners'

      expect(response.status).to eq 200
    end
  end
end
