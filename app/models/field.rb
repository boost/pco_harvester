# frozen_string_literal: true

class Field < ApplicationRecord
  belongs_to :transformation_definition
end
