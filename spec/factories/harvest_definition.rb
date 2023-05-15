FactoryBot.define do
  factory :harvest_definition do
    association :content_partner
    association :extraction_definition
    association :extraction_job
    association :transformation_definition
    association :destination
  end
end
