require "rails_helper"

RSpec.describe "Segments API", type: :request do
  describe 'V1' do
    describe 'POST /api/v1/segments' do
      context 'when the request fails' do
        context 'due to a malformation' do
          let(:segment_params) { { foo: {} } }

          subject { post '/api/v1/segments', params: { user: segment_params } }

          it { expect { subject }.to change { response&.status }.to(400) }
          it { expect { subject }.not_to change { parsed_body }.from({}) }
        end

        context 'due to an empty segment' do
          let(:data) { [] }
          let(:segment_params) { attributes_for(:segment).merge(data: data) }

          subject { post '/api/v1/segments', as: :json, params: { segment: segment_params } }

          it { expect { subject }.to change { response&.status }.to(422) }
          it { expect { subject }.to change { parsed_body[:data] }.to([I18n.t(:blank, scope: %i[errors messages])]) }
        end

        context 'due to an malformed segment' do
          let(:data) { [1, true, 'foo'] }
          let(:segment_params) { attributes_for(:segment).merge(data: data) }

          subject { post '/api/v1/segments', as: :json, params: { segment: segment_params } }

          it { expect { subject }.to change { response&.status }.to(422) }
          it { expect { subject }.to change { parsed_body[:data] }.to([I18n.t(:format, scope: %i[errors messages segment])]) }
        end

        context 'due to a non existing fragment' do
          let(:data) { [{ foo: true }] }
          let(:segment_params) { attributes_for(:segment).merge(data: data) }

          subject { post '/api/v1/segments', as: :json, params: { segment: segment_params } }

          it { expect { subject }.to change { response&.status }.to(422) }
          it { expect { subject }.to change { parsed_body[:data] }.to([I18n.t(:reflection, scope: %i[errors messages segment])]) }
        end

        context 'due to every sub segment being empty' do
          let(:data) { [{}, {}, {}] }
          let(:segment_params) { attributes_for(:segment).merge(data: data) }

          subject { post '/api/v1/segments', as: :json, params: { segment: segment_params } }

          it { expect { subject }.to change { response&.status }.to(422) }
          it { expect { subject }.to change { parsed_body[:data] }.to([I18n.t(:presence, scope: %i[errors messages segment])]) }
        end
      end

      context 'when the request succeeds' do
        context 'with one sub segment' do
          let(:data) { [{ is_active: true }] }
          let(:segment_params) { attributes_for(:segment).merge({ data: data }) }

          subject { post '/api/v1/segments', as: :json, params: { segment: segment_params } }

          it { expect { subject }.to change { response&.status }.to(201) }
          it { expect { subject }.not_to change { parsed_body }.from({}) }

          it { expect { subject }.to change { Segment.last&.data }.to(data.map(&:stringify_keys)) }
        end

        context 'with two sub segments' do
          let(:data) { [{ is_active: true }, { sex: 'male' }] }
          let(:segment_params) { attributes_for(:segment).merge({ data: data }) }

          subject { post '/api/v1/segments', as: :json, params: { segment: segment_params } }

          it { expect { subject }.to change { response&.status }.to(201) }
          it { expect { subject }.not_to change { parsed_body }.from({}) }

          it { expect { subject }.to change { Segment.last&.data }.to(data.map(&:stringify_keys)) }
        end
      end
    end
  end
end
