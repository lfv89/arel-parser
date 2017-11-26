FactoryBot.define do
  factory :user do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    email { Faker::Internet.email }
    birth_date { Faker::Date.birthday }
    admission_date { Faker::Date.backward(90) }
    sex { %w(male female).sample }
    last_sign_in_at { Faker::Date.backward(7) }
  end
end
