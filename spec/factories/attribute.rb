# frozen_string_literal: true

FactoryBot.define do
  factory :attribute do
    name        { 'Title' }
    description { 'Description' }
    block       { "record['title']" }
   end
end
