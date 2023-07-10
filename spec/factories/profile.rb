FactoryBot.define do
  factory :profile do
    name { Faker::Internet.username }
    introduction { Faker::Lorem.paragraph }
    user
    after(:build) do |post|
      post.cover.attach(io: File.open(Rails.root.join('spec/fixtures/valid_image.jpg')), filename: 'cover.jpg')
      post.avatar.attach(io: File.open(Rails.root.join('spec/fixtures/valid_image.jpg')), filename: 'avatar.jpg')
    end
  end
end
