# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :recoverable, :rememberable, :validatable, :invitable,
         :two_factor_authenticatable,
         otp_secret_encryption_key: ENV.fetch('OTP_ENCRYPTION_KEY', nil)

  enum :role, { harvester: 0, admin: 1 }
end
