require 'rails_helper'

RSpec.describe "ContentPartners", type: :request do
  describe "GET /index" do
    it 'renders a the :index template' do
      get '/content_partners'

      expect(response).to render_template(:new)
    end
  end
end
