require 'rails_helper'

RSpec.describe SegmentParser, type: :model do
  let(:segmented) { User }
  let(:segment_parser) { described_class.new(segment) }

  subject { segmented.where(segment_parser.parse).count }

  describe 'One single fielded segment' do
    let(:segment) { Segment.new(data: [{ field => value }]) }

    context 'when the field is a tag' do
      let(:field) { :tags }
      let(:value) { 3.times.map { attributes_for(:tag)[:name] } }

      before do
        user = create(:user)

        value.each { |name| create(:tag, name: name, users: [user]) }
        value.each { |name| create(:tag, name: name.chop, users: [user]) }
      end

      it { is_expected.to eq(1) }
    end

    context 'when the field is a date' do
      context 'and the range has only 2 days' do
        let(:upper) { Date.today }
        let(:lower) { Date.yesterday }

        let(:field) { :admission_date }
        let(:value) { [lower, upper] }

        before { create(:user, { field => lower.to_date }) }

        it { is_expected.to eq(1) }
      end

      context 'and the range has more than 2 days' do
        let(:upper) { Date.today - 3.days }
        let(:lower) { Date.today - 5.days }

        let(:field) { :admission_date }
        let(:value) { [lower, upper] }

        before { create(:user, { field => (lower + 2.days).to_date }) }

        it { is_expected.to eq(1) }
      end
    end

    context 'when the field is a string' do
      let(:field) { :sex }
      let(:value) { attributes_for(:user)[field] }

      before { create(:user, { field => value }) }

      it { is_expected.to eq(1) }
    end

    context 'when the field is a boolean' do
      let(:field) { :is_active }
      let(:value) { attributes_for(:user)[field] }

      before { create(:user, { field => true }) }
      before { create(:user, { field => false }) }

      it { is_expected.to eq(1) }
    end

    context 'when the field is a datetime' do
      context 'and the range has only 2 days' do
        let(:lower) { 1.day.ago }
        let(:upper) { Time.zone.now }

        let(:field) { :last_sign_in_at }
        let(:value) { [lower, upper] }

        before { create(:user, { field => (lower) }) }

        it { is_expected.to eq(1) }
      end

      context 'and the range has more than 2 days' do
        let(:upper) { Time.zone.now - 3.days }
        let(:lower) { Time.zone.now - 5.days }

        let(:field) { :last_sign_in_at }
        let(:value) { [lower, upper] }

        before { create(:user, { field => (lower + 2.days) }) }

        it { is_expected.to eq(1) }
      end
    end
  end

  describe 'One double fielded segment' do
    let(:segment) { Segment.new(data: [{ field1 => value1, field2 => value2 }]) }

    context 'when the fields are both string' do
      let(:field1) { :sex }
      let(:field2) { :last_name }

      let(:value1) { attributes_for(:user)[field1] }
      let(:value2) { attributes_for(:user)[field2] }

      before { create(:user, { field1 => value1, field2 => value2 }) }
      before { create(:user, { field1 => value1, field2 => value2.chop }) }

      it { is_expected.to eq(1) }
    end

    context 'when the fields are both date' do
      let(:upper1) { Date.today }
      let(:lower1) { Date.yesterday }

      let(:upper2) { 1.month.ago }
      let(:lower2) { 3.months.ago }

      let(:field1) { :birth_date }
      let(:field2) { :admission_date }

      let(:value1) { [lower1, upper1] }
      let(:value2) { [lower2, upper2] }

      before { create(:user, { field1 => lower1, field2 => upper2.to_date }) }

      before { create(:user, { field1 => lower1, field2 => (lower2 - 1.day).to_date }) }
      before { create(:user, { field1 => (upper1 + 1.day).to_date, field2 => lower2.to_date }) }

      it { is_expected.to eq(1) }
    end

    context 'when a field is tag and the other is a date' do
      let(:field1) { :tags }
      let(:field2) { :admission_date }

      let(:upper) { 3.months.ago }
      let(:lower) { 5.months.ago }

      let(:value1) { 3.times.map { attributes_for(:tag)[:name] } }
      let(:value2) { [lower, upper] }

      before { create(:user, { field2 => lower.to_date }) }

      before do
        user = create(:user, { field2 => (upper - 1.month).to_date })
        value1.each { |name| create(:tag, name: name, users: [user]) }

        other_user = create(:user, { field2 => (upper + 1.month).to_date })
        value1.each { |name| create(:tag, name: name, users: [other_user]) }
      end

      it { is_expected.to eq(1) }
    end

    context 'when a field is string and the other is a date' do
      let(:field1) { :birth_date }
      let(:field2) { :last_name }

      let(:upper) { 3.months.ago }
      let(:lower) { 5.months.ago }

      let(:value1) { [lower, upper] }
      let(:value2) { attributes_for(:user)[field2] }

      before { create(:user, { field1 => lower.to_date, field2 => value2 }) }

      before { create(:user, { field1 => upper.to_date, field2 => value2.chop }) }
      before { create(:user, { field1 => (lower - 1.week).to_date, field2 => value2 }) }

      it { is_expected.to eq(1) }
    end

    context 'when a field is a boolean and the other is a date' do
      let(:field1) { :is_active }
      let(:value1) { attributes_for(:user)[field1] }

      let(:field2) { :birth_date }
      let(:value2) { [lower, upper] }

      let(:upper) { 3.months.ago }
      let(:lower) { 9.months.ago }

      before { create(:user, { field1 => value1, field2 => (lower + 3.months).to_date }) }

      before { create(:user, { field1 => value1, field2 => (upper + 3.months).to_date }) }
      before { create(:user, { field1 => !value1, field2 => (upper - 3.months).to_date }) }

      it { is_expected.to eq(1) }
    end

    context 'when a field is a boolean and the other is a datetime' do
      let(:field1) { :is_active }
      let(:value1) { attributes_for(:user)[field1] }

      let(:field2) { :last_sign_in_at }
      let(:value2) { [lower, upper] }

      let(:upper) { 3.months.ago }
      let(:lower) { 9.months.ago }

      before { create(:user, { field1 => value1, field2 => lower + 3.months }) }

      before { create(:user, { field1 => value1, field2 => upper + 3.months }) }
      before { create(:user, { field1 => !value1, field2 => upper - 3.months }) }

      it { is_expected.to eq(1) }
    end
  end

  describe 'Two single fielded segment' do
    let(:segment) { Segment.new(data: [{seg1_field1 => seg1_value1}, {seg2_field1 => seg2_value1}]) }

    context 'when the first segment has 1 field (date) and the second has 1 field (boolean)' do
      let(:upper) { 10.months.ago }
      let(:lower) { 12.months.ago }

      let(:seg1_field1) { :admission_date }
      let(:seg1_value1) { [lower, upper] }

      let(:seg2_field1) { :is_active }
      let(:seg2_value1) { attributes_for(:user)[seg2_field1] }

      before { create(:user, { seg2_field1 => seg2_value1 }) }
      before { create(:user, { seg1_field1 => (upper - 1.month).to_date }) }
      before { create(:user, { seg1_field1 => (upper + 1.month).to_date, seg2_field1 => !seg2_value1 }) }

      it { is_expected.to eq(2) }
    end

    context 'when the first segment has 1 field (tags) and the second has 1 field (string)' do
      let(:seg1_field1) { :tags }
      let(:seg2_field1) { :last_name }

      let(:seg1_value1) { [attributes_for(:tag)[:name]] }
      let(:seg2_value1) { attributes_for(:user)[seg2_field1] }

      before { create(:user, { seg2_field1 => seg2_value1 }) }
      before { seg1_value1.each { |name| create(:tag, name: name, users: [create(:user)]) } }
      before { seg1_value1.each { |name| create(:tag, name: name.chop, users: [create(:user)]) } }

      it { is_expected.to eq(2) }
    end

    context 'when the first segment has 1 field (boolean) and the second has 1 field (string)' do
      let(:seg1_field1) { :is_active }
      let(:seg2_field1) { :last_name }

      let(:seg1_value1) { attributes_for(:user)[seg1_field1] }
      let(:seg2_value1) { attributes_for(:user)[seg2_field1] }

      before { create(:user, { seg1_field1 => seg1_value1, seg2_field1 => seg2_value1.chop }) }
      before { create(:user, { seg1_field1 => !seg1_value1, seg2_field1 => seg2_value1 }) }

      it { is_expected.to eq(2) }
    end
  end
end
