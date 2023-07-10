FactoryBot.define do
  factory :contact do
    email { Faker::Internet.email }
    subject { Faker::Lorem.sentence }
    message { Faker::Lorem.paragraph }
  end
end
