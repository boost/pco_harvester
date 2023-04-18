# frozen_string_literal: true

class ContentPartner < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
