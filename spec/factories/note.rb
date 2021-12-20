FactoryBot.define do
  factory :note do
    city { Faker::Address.city  }
    description { Faker::Lorem.sentence }
    user
  end
end