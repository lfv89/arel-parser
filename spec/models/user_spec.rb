require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Fields' do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:birth_date).of_type(:date) }
    it { is_expected.to have_db_column(:admission_date).of_type(:date) }
    it { is_expected.to have_db_column(:is_active).of_type(:boolean) }
    it { is_expected.to have_db_column(:sex).of_type(:string) }
    it { is_expected.to have_db_column(:last_sign_in_at).of_type(:time) }
  end

  describe 'Validations' do
    it { is_expected.to validate_inclusion_of(:sex).in_array(%w(male female)) }
  end

  describe 'Relationships' do
    it { is_expected.to have_and_belong_to_many(:tags) }
  end
end
