FactoryBot.define do
  factory :post do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.city }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    user
    after(:build) do |post|
      post.image.attach(io: File.open(Rails.root.join('spec/fixtures/valid_image.jpg')), filename: 'image.jpg')
    end
  end

  factory :post_no_image, class: "Post" do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.city }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    user
  end
end
