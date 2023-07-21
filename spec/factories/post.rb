FactoryBot.define do
  factory :post do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.city }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    user
    after(:build) do |post|
      post.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/valid_image.jpg')),
                        filename: "#{Faker::Internet.slug}.jpg")
    end
  end
end
