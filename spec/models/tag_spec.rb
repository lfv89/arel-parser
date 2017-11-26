require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'Fields' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  describe 'Relationships' do
    it { is_expected.to have_and_belong_to_many(:users) }
  end
end
