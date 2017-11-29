FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    birth_date { Faker::Date.birthday }
    admission_date { Faker::Date.backward(90) }
    is_active { Faker::Boolean.boolean }
    sex { %w(male female).sample }
    last_sign_in_at { Faker::Time.backward(7) }
  end
end
