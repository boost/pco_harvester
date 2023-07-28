# frozen_string_literal: true

FactoryBot.define do
  factory :parameter do
    key  { 'key' }
    value { 'ab.cd.ef.gh' }

    association :request
  end
end
