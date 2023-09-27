# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :pipeline
  belongs_to :destination
end
