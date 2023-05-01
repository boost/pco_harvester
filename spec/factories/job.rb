FactoryBot.define do
  factory :job do
    status { 'queued' }
    kind   { 'full' }

    updated_at { DateTime.parse('2000-01-15 13:30:00') }
    created_at { DateTime.parse('2000-01-15 13:30:00') }

    association :extraction_definition
  end
end
