FactoryBot.define do
  factory :segment do
    name { Faker::Name.unique.name }
  end
end
