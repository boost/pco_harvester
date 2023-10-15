# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SchedulesHelper do
  let(:pipeline)                   { create(:pipeline) }
  let(:destination)                { create(:destination) }
  let(:harvest_definition)         { create(:harvest_definition, pipeline:) }
  let(:harvest_definitions_to_run) { [harvest_definition.id] }

  describe '#schedule_run_label' do
    it 'returns Runs daily at when the schedule is daily' do
      schedule = create(:schedule, frequency: 0, day: 1, pipeline:, destination:, harvest_definitions_to_run:)

      expect(schedule_run_label(schedule)).to eq 'Runs daily at'
    end

    it 'returns Runs weekly at when the schedule is weekly' do
      schedule = create(:schedule, frequency: 1, day: 1, pipeline:, destination:, harvest_definitions_to_run:)

      expect(schedule_run_label(schedule)).to eq 'Runs weekly at'
    end

    it 'returns Runs monthly at when the schedule is bi monthly' do
      schedule = create(:schedule, frequency: 2, day: 1, pipeline:, destination:, harvest_definitions_to_run:,
                                   bi_monthly_day_one: 1, bi_monthly_day_two: 2)

      expect(schedule_run_label(schedule)).to eq 'Runs monthly at'
    end

    it 'returns Runs monthly at when the schedule is monthly' do
      schedule = create(:schedule, frequency: 3, day: 1, pipeline:, destination:, harvest_definitions_to_run:,
                                   day_of_the_month: 1)

      expect(schedule_run_label(schedule)).to eq 'Runs monthly at'
    end
  end

  describe '#schedule_run_text' do
    it 'returns the time if the schedule is daily' do
      schedule = create(:schedule, time: '12:45PM', frequency: 0, day: 1, pipeline:, destination:,
                                   harvest_definitions_to_run:)

      expect(schedule_run_text(schedule)).to eq '12:45PM'
    end

    it 'returns the time on day if the schedule is weekly' do
      schedule = create(:schedule, time: '12:45PM', frequency: 1, day: 1, pipeline:, destination:,
                                   harvest_definitions_to_run:)

      expect(schedule_run_text(schedule)).to eq '12:45PM on Monday'
    end

    it 'returns the time on the day of the month' do
      schedule = create(:schedule, time: '12:45PM', frequency: 3, day: 1, pipeline:, destination:,
                                   harvest_definitions_to_run:, day_of_the_month: 1)

      expect(schedule_run_text(schedule)).to eq '12:45PM on the 1st'
    end

    it 'returns the time on the first day of the month and the second day of the month' do
      schedule = create(:schedule, time: '12:45PM', frequency: 2, day: 1, pipeline:, destination:,
                                   harvest_definitions_to_run:, bi_monthly_day_one: 1, bi_monthly_day_two: 2)

      expect(schedule_run_text(schedule)).to eq '12:45PM on the 1st and 2nd'
    end
  end
end
