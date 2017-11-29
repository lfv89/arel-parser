require 'rails_helper'

RSpec.describe Segment, type: :model do
  describe 'Fields' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:data).of_type(:json) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    describe 'The segment validation' do
      subject { described_class.new(data: data) }

      context 'with a null data' do
        let(:data) { nil }

        before { subject.valid? }

        it { is_expected.to have(1).error_on(:data) }
      end

      context 'with an empty data array' do
        let(:data) { [] }

        before { subject.valid? }

        it { is_expected.to have(1).error_on(:data) }
      end

      context 'with non-object sub segments' do
        let(:data) { ['foo', 2, false, {}] }

        before { subject.valid? }

        it { is_expected.to have(1).error_on(:data) }
      end

      context 'with an array of empty objects' do
        let(:data) { [{}, {}] }

        before { subject.valid? }

        it { is_expected.to have(1).error_on(:data) }
      end

      context 'with an non existent fragment name' do
        let(:data) { [{ foo: 'bar' }] }

        before { subject.valid? }

        it { is_expected.to have(1).error_on(:data) }
      end

      context 'with an existent fragment name' do
        context 'and the fragment is an user field' do
          let(:data) { [{ is_active: true }] }

          before { subject.valid? }

          it { is_expected.to have(0).errors_on(:data) }
        end

        context 'and the fragment is an user association' do
          let(:data) { [{ tags: [:foo] }] }

          before { subject.valid? }

          it { is_expected.to have(0).errors_on(:data) }
        end
      end
    end
  end
end
