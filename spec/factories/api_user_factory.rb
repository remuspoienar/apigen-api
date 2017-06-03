FactoryGirl.define do
  factory :api_user do
    name { Faker::Name.name_with_middle }
    email { Faker::Internet.email }
    password { Faker::Internet.password(6, 18) }
  end
end