# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :pipeline
  belongs_to :destination

  serialize :harvest_definitions_to_run, Array

  validates :frequency, presence: true
  validates :time,      presence: true
  validates :harvest_definitions_to_run, presence: true

  enum :frequency, { daily: 0, weekly: 1, fortnightly: 2, monthly: 3 }
  enum :day,       { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }, prefix: :on

  validates :day, presence: true,              if: -> { weekly? || fortnightly? }
  validates :day_of_the_month, presence: true, if: -> { monthly? }
end
