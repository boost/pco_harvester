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

    association :content_partner
  end
end
