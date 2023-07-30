# frozen_string_literal: true

FactoryBot.define do
  factory :pipeline do
    name { 'DigitalNZ Production' }
    description { 'Description' }

    trait :ngataonga do
      name { 'Ngā Taonga' }
      after :create do |pipeline|
        harvest_definition = create(:harvest_definition, pipeline:)
        harvest_definition.update(extraction_definition: create(:extraction_definition, :ngataonga))
      end
    end

    trait :figshare do
      name { 'Figshare' }

      after :create do |pipeline|
        harvest_definition = create(:harvest_definition, pipeline:)
        harvest_definition.update(extraction_definition: create(:extraction_definition))
      end
    end
  end
end
