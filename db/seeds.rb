require "open-uri"

def create_category_data
  Category.create!([
    { name: "ポートレート" },
    {name: "風景"},
    {name: "自然"},
    {name: "動物"},
    {name: "街"},
    {name: "夜"},
    {name: "建築"},
    {name: "山"},
    {name: "海"},
    {name: "空"},
    {name: "道"},
    {name: "天体"},
    {name: "スナップ"}])
end

def create_user_profile_data
  user_num = 10
  user_num.times do |n|
    test_user_num = n + 1
    user = User.create!(
      email: Faker::Internet.email,
      password: Faker::Internet.password,
      confirmed_at: Time.now
    ) do |user|
      user.build_profile
      user.profile.name = "テストユーザー#{ test_user_num }"
      user.profile.introduction = Faker::Lorem.paragraph
    end

    if n.even?
      avatar_url = Faker::Avatar.image(slug: user.email, size: '50x50')
      user.profile.avatar.attach(io: URI.open(avatar_url), filename: 'avatar.png')
    end

    if n.odd?
      user.profile.cover.attach(io: File.open(Rails.root.join("app/assets/images/seeds/test#{ n }.jpg")), filename: 'cover.jpg')
    end
  end
end

def create_post_data
  user_post_num = 2
  User.all.each_with_index do |user, i|
    user_post_num.times do |n|
      post_num = (i + 1) + (n * 10)
      post = user.posts.new(
            title: "テスト投稿#{ post_num }",
            description: "注意:テスト投稿のため、間違った情報で表示されています。",
            location: Faker::Address.city,
            latitude: Faker::Address.latitude,
            longitude: Faker::Address.longitude
            )
      post.image.attach(io: File.open(Rails.root.join("app/assets/images/seeds/test#{ post_num }.jpg")), filename: 'image.jpg')
      post.save!
      post.post_category_relations.create!([{ category_id: i + 1 }, { category_id: i + n + 2 }])
    end
  end
end

def create_follow_data
  follow_num = 4
  User.all.each_with_index do |user, i|
    follow_num.times do |n|
      follow_user_id = rand(1..10)
      if user.same_user?(follow_user_id)
        break
      end
      if user.following?(follow_user_id)
        break
      end
      user.relationships.create!(follow_id: follow_user_id)
    end
  end
end

def create_like_data
  like_num = 4
  User.all.each_with_index do |user, i|
    like_num.times do |n|
      post_id = rand(1..20)
      if user.like?(post_id)
        break
      end
      user.likes.create!(post_id: post_id)
    end
  end
end

def create_bookmark_data
  bookmark_num = 4
  User.all.each_with_index do |user, i|
    bookmark_num.times do |n|
      post_id = rand(1..20)
      if user.bookmarking?(post_id)
        break
      end
      user.bookmarks.create!(post_id: post_id)
    end
  end
end

def create_comment_data
  comment_num = 4
  User.all.each_with_index do |user, i|
    comment_num.times do |n|
      post_id = rand(1..20)
      user.comments.create!(post_id: post_id, content: Faker::Lorem.sentence)
    end
  end
end

def create_contact_date
  contact_num = 4
  contact_num.times do |n|
    Contact.create!(
      email: Faker::Internet.email,
      subject: Faker::Lorem.sentence,
      message: Faker::Lorem.paragraph
    )
  end
end

create_category_data
create_user_profile_data
create_post_data
create_follow_data
create_like_data
create_bookmark_data
create_comment_data
create_contact_date
