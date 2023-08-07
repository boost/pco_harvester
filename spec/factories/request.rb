# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    http_method { 'GET' }

    association :extraction_definition

    trait :figshare_initial_request do
      after(:create) do |request|
        create(:parameter, content: 'v1',       kind: 'slug', request:)
        create(:parameter, content: 'articles', kind: 'slug', request:)
        create(:parameter, content: 'search',   kind: 'slug', request:)

        create(:parameter, name: 'search_for',   content: 'zealand', request:)
        create(:parameter, name: 'page',         content: '1', request:)
        create(:parameter, name: 'itemsPerPage', content: '10', request:)
      end
    end
    
    trait :figshare_main_request do
      after(:create) do |request|
        create(:parameter, content: 'v1',       kind: 'slug', request:)
        create(:parameter, content: 'articles', kind: 'slug', request:)
        create(:parameter, content: 'search',   kind: 'slug', request:)

        create(:parameter, name: 'search_for',   content: 'zealand', request:)
        create(:parameter, name: 'page',         content: "JSON.parse(response)['page_nr'] + 1", request:, dynamic: true)
        create(:parameter, name: 'itemsPerPage', content: '10', request:)
      end
    end
  end
end
