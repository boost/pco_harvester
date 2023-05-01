require 'rails_helper'

RSpec.describe "Transformations", type: :request do
  let(:content_partner) { create(:content_partner) }

  describe '#new' do
    it 'renders the new form' do
      get new_content_partner_transformation_path(content_partner)

      expect(response.status).to eq 200
    end
  end
end
