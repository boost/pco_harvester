# frozen_string_literal: true

FactoryBot.define do
  factory :content_source do
    name { Faker::Company.name }

    trait :ngataonga do
      name { 'Ngā Taonga' }
      after :create do |content_source|
        create(:extraction_definition, :ngataonga, content_source:)
      end
    end

    trait :figshare do
      name { 'Figshare' }

      after :create do |content_source|
        create(:harvest_definition, content_source:)
        create(:extraction_definition, content_source:)
      end
    end
  end
end
