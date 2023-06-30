# frozen_string_literal: true

class Header < ApplicationRecord
  belongs_to :extraction_definition
  
  validates :name, presence: true
  validates :value, presence: true
end
