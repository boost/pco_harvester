FactoryBot.define do
  factory :content_partner do
    name { Faker::Company.name }

    trait :ngataonga do
      name { 'Ngā Taonga' }
      after :create do |content_partner|
        create(:extraction_definition, :ngataonga, content_partner:)
      end
    end
  end
end
