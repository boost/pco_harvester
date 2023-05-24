# frozen_string_literal: true

FactoryBot.define do
  factory :content_partner do
    name { Faker::Company.name }

    trait :ngataonga do
      name { 'Ngā Taonga' }
      after :create do |content_partner|
        create(:extraction_definition, :ngataonga, content_partner:)
      end
    end

    trait :figshare do
      name { 'Figshare' }

      after :create do |content_partner|
        create(:harvest_definition, content_partner:)
        create(:extraction_definition, content_partner:)
      end
    end
  end
end
