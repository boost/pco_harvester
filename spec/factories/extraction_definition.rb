# frozen_string_literal: true

FactoryBot.define do
  factory :extraction_definition do
    name { Faker::Internet.domain_name }
    format { 'JSON' }
    base_url { "#{Faker::Internet.url}?param=value" }
    throttle { 0 }

    pagination_type { 'item' }
    page_parameter { 'page' }
    page { 1 }
    per_page_parameter { 'per_page' }
    per_page { 50 }
    total_selector { '$.totalObjects' }

    trait :ngataonga do
      name { 'api.ngataonga.org.nz' }
      base_url { 'http://api.ngataonga.org.nz/records.json/?api_key=MYAPIKEY&and[has_media]=true' }
      throttle { 0 }
      page_parameter { 'page' }
      page { 1 }
      per_page_parameter { 'per_page' }
      per_page { 50 }
      total_selector { '$..result_count' }
    end

    association :content_partner
  end
end
