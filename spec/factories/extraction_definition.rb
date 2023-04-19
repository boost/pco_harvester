FactoryBot.define do
  factory :extraction_definition do
    name { Faker::Internet.domain_name }

    association :content_partner
  end
end
