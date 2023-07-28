# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    kind { 0 }

    association :extraction_definition
  end
end
