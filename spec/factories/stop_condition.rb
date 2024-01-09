# frozen_string_literal: true

FactoryBot.define do
  factory :stop_condition do
    name { 'Name' }
    content { "JsonPath.new('$.page').on(response).first == 1" }
  end
end
