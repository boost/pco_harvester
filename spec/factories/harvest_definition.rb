FactoryBot.define do
  factory :harvest_definition do
    association :content_partner
    association :extraction_definition
    association :job
    association :transformation_definition
    association :destination
  end
end
