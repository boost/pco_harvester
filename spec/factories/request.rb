# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    http_method { 'GET' }

    association :extraction_definition

    trait :figshare do
      after(:create) do |request|
        create(:parameter, content: 'v1',       kind: 'slug', request:)
        create(:parameter, content: 'articles', kind: 'slug', request:)
        create(:parameter, content: 'search',   kind: 'slug', request:)

        create(:parameter, name: 'search_for',   content: 'zealand', request:)
        create(:parameter, name: 'page',         content: '1', request:)
        create(:parameter, name: 'itemsPerPage', content: '10', request:)
      end
    end
  end
end
