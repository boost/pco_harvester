# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    http_method { 'GET' }

    association :extraction_definition
  end
end
