require "rails_helper"

RSpec.describe "Users API", type: :request do
  describe 'V1' do
    describe 'GET /api/v1/users' do
      context 'using a non existent segmentation' do
        subject { get '/api/v1/users', params: { segment: 'foo' } }

        it { expect { subject }.to change { response&.status }.to(404) }
        it { expect { subject }.not_to change { parsed_body }.from({}) }
      end

      context 'using a sex segmentation' do
        let!(:male_user) { create(:user, sex: 'male') }
        let!(:female_user) { create(:user, sex: 'female') }

        context 'and segment with 1 sub segments' do
          let!(:segment) { create(:segment, data: [{ sex: 'male' }]  ) }

          before { get '/api/v1/users', params: { segment: segment.name } }

          it { expect(parsed_body).to have(1).items }
          it { expect(parsed_body.pluck(:id)).to eq([male_user.id]) }
        end

        context 'and a segment with 2 sub segments' do
          let!(:segment) { create(:segment, data: [{ sex: 'male' }, { sex: 'female' }]  ) }

          before { get '/api/v1/users', params: { segment: segment.name } }

          it { expect(parsed_body).to have(2).items }
          it { expect(parsed_body.pluck(:id)).to match_array([male_user.id, female_user.id]) }
        end
      end
    end

    describe 'POST /api/v1/users' do
      context 'when the request fails' do
        context 'due to a malformation' do
          let(:user_params) { }

          subject { post '/api/v1/users', params: { foo: user_params } }

          it { expect { subject }.to change { response&.status }.to(400) }
          it { expect { subject }.not_to change { parsed_body }.from({}) }
        end

        context 'due to a missed required param' do
          let(:user_params) { attributes_for(:user) }
          let(:required_missing_param) { :first_name }

          subject do
            user_params.delete(required_missing_param)
            post '/api/v1/users', as: :json, params: { user: user_params }
          end

          it { expect { subject }.to change { response&.status }.to(422) }

          it { expect { subject }.to change { parsed_body[required_missing_param] }
            .to([t(:blank, scope: %i[errors messages])]) }
        end
      end

      context 'when the request succeeds' do
        let(:user_params) { attributes_for(:user) }

        subject { post '/api/v1/users', as: :json, params: { user: user_params } }

        it { expect { subject }.to change { response&.status }.to(201) }
        it { expect { subject }.not_to change { parsed_body }.from({}) }

        it { expect { subject }.to change(User, :count).from(0).to(1) }

        it { expect { subject }.to change { User.last&.first_name }.to(user_params[:first_name]) }
        it { expect { subject }.to change { User.last&.last_name }.to(user_params[:last_name]) }
        it { expect { subject }.to change { User.last&.email }.to(user_params[:email]) }
        it { expect { subject }.to change { User.last&.birth_date }.to(user_params[:birth_date]) }
        it { expect { subject }.to change { User.last&.admission_date }.to(user_params[:admission_date]) }
        it { expect { subject }.to change { User.last&.is_active }.to(user_params[:is_active]) }
        it { expect { subject }.to change { User.last&.sex }.to(user_params[:sex]) }
        it { expect { subject }.to change { User.last&.last_sign_in_at }.to(user_params[:last_sign_in_at]) }

        context 'with tags' do
          let(:tags) { 3.times.map { attributes_for(:tag) } }

          before { user_params.merge!({ tags_attributes: tags }) }

          it { expect { subject }.not_to change { parsed_body }.from({}) }
          it { expect { subject }.to change { User.last&.tags&.pluck(:name) }.to(tags.pluck(:name)) }
        end
      end
    end
  end
end
