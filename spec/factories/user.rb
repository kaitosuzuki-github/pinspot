FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
    confirmed_at { Time.now }

    after(:build) do |user|
      user.build_profile
      user.profile.name = Faker::Internet.username
    end
  end
end
