FactoryBot.define do
  factory :transformation_definition do    
    name { 'Name' }
    record_selector { '$..results' }
   
  end
end
