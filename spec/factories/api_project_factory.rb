FactoryGirl.define do
  factory :api_project do
    name { Faker::Company.name }
    launched { false }
    api_host { Faker::Internet.url }

    association :created_by, factory: :api_user
  end
end