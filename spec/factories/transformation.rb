FactoryBot.define do
  factory :transformation do
    name { 'Name' }
    record_selector { '$..results' }
   
  end
end
