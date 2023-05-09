# frozen_string_literal: true

FactoryBot.define do
  factory :field do
    name        { 'title' }
    block       { "JsonPath.new('title').on(record).first" }
   end
end
