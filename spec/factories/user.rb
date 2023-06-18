# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email    { Faker::Internet.email }
    password { Faker::Internet.password }
    role { 'harvester' }
    invitation_sent_at { DateTime.now }
    two_factor_setup { false }
    otp_required_for_login { false }
    enforce_two_factor { false }

    trait :two_factor_setup do
      two_factor_setup { true }
      otp_required_for_login { true }

      after(:build) do |user|
        user.otp_secret = User.generate_otp_secret
      end
    end

    trait :enforce_two_factor do
      enforce_two_factor { true }
    end
  end
end
