require 'rails_helper'

RSpec.describe "Segmentations API", type: :request do
  describe 'V1' do
    describe 'GET /api/v1/segmentations' do
      context 'using a non existent segmentation' do
        subject { get '/api/v1/segmentations/foo' }

        it { expect { subject }.to change { response&.status }.to(404) }
        it { expect { subject }.not_to change { parsed_body }.from({}) }
      end

      context 'using a sex segmentation' do
        let!(:male_user) { create(:user, sex: 'male') }
        let!(:female_user) { create(:user, sex: 'female') }

        context 'and segment with 1 sub segments' do
          let!(:segment) { create(:segment, data: [{ sex: 'male' }]  ) }

          before { get "/api/v1/segmentations/#{segment.name.parameterize}" }

          it { expect(parsed_body).to have(1).items }
          it { expect(parsed_body.pluck(:id)).to eq([male_user.id]) }
        end

        context 'and a segment with 2 sub segments' do
          let!(:segment) { create(:segment, data: [{ sex: 'male' }, { sex: 'female' }]  ) }

          before { get "/api/v1/segmentations/#{segment.name.parameterize}" }

          it { expect(parsed_body).to have(2).items }
          it { expect(parsed_body.pluck(:id)).to match_array([male_user.id, female_user.id]) }
        end
      end
    end
  end
end
