# frozen_string_literal: true

FactoryBot.define do
  factory :header do
    name { 'x-forwarded-for' }
    value { 'ab.cd.ef.gh' }

    association :extraction_definition
  end
end
