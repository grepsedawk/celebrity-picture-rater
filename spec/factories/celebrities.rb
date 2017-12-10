FactoryBot.define do
  factory :celebrity do
    name { Faker::Name.name }
  end
end
