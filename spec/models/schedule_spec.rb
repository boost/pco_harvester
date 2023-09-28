require 'rails_helper'

RSpec.describe Schedule, type: :model do
  let(:pipeline)                   { create(:pipeline) }
  let(:destination)                { create(:destination) }
  let(:harvest_definition)         { create(:harvest_definition, pipeline:) }
  let(:harvest_definitions_to_run) { [harvest_definition.id] }

  describe 'associations' do
    it { is_expected.to belong_to(:pipeline) }
    it { is_expected.to belong_to(:destination) }
  end

  describe 'frequency' do
    it 'can be daily' do
      daily = build(:schedule, frequency: 0, pipeline:, destination:, harvest_definitions_to_run:)

      expect(daily.daily?).to be true
    end

    it 'can be weekly' do
      weekly = build(:schedule, frequency: 1, pipeline:, destination:, harvest_definitions_to_run:)
      expect(weekly.weekly?).to be true
    end

    it 'can be fortnightly' do
      fortnightly = build(:schedule, frequency: 2, pipeline:, destination:, harvest_definitions_to_run:)
      expect(fortnightly.fortnightly?).to be true
    end

    it 'can be monthly' do
      monthly = build(:schedule, frequency: 3, pipeline:, destination:, harvest_definitions_to_run:)
      expect(monthly.monthly?).to be true
    end
  end

  describe 'day' do
    it 'can be on Monday' do
      schedule = create(:schedule, frequency: 0, day: 1, pipeline:, destination:, harvest_definitions_to_run:)

      expect(schedule.on_monday?).to be true
    end

    it 'can be on Tuesday' do
      schedule = create(:schedule, frequency: 0, day: 2, pipeline:, destination:, harvest_definitions_to_run:)

      expect(schedule.on_tuesday?).to be true
    end

    it 'can be on Wednesday' do
      schedule = create(:schedule, frequency: 0, day: 3, pipeline:, destination:, harvest_definitions_to_run:)

      expect(schedule.on_wednesday?).to be true
    end

    it 'can be on Thursday' do
      schedule = create(:schedule, frequency: 0, day: 4, pipeline:, destination:, harvest_definitions_to_run:)

      expect(schedule.on_thursday?).to be true
    end

    it 'can be on Friday' do
      schedule = create(:schedule, frequency: 0, day: 5, pipeline:, destination:, harvest_definitions_to_run:)

      expect(schedule.on_friday?).to be true
    end

    it 'can be on Saturday' do
      schedule = create(:schedule, frequency: 0, day: 6, pipeline:, destination:, harvest_definitions_to_run:)

      expect(schedule.on_saturday?).to be true
    end

    it 'can be on Sunday' do
      schedule = create(:schedule, frequency: 0, day: 0, pipeline:, destination:, harvest_definitions_to_run:)

      expect(schedule.on_sunday?).to be true
    end
  end
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:pipeline).with_message('must exist') }
    it { is_expected.to validate_presence_of(:destination).with_message('must exist') }
    it { is_expected.to validate_presence_of(:frequency).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:time).with_message("can't be blank") }
    it { is_expected.to validate_presence_of(:harvest_definitions_to_run).with_message("can't be blank") }

    context 'weekly' do
      subject { build(:schedule, frequency: :weekly, pipeline:, destination:, harvest_definitions_to_run:) }

      it { is_expected.to validate_presence_of(:day).with_message("can't be blank") }
    end

    context 'fortnightly' do
      subject { build(:schedule, frequency: :fortnightly, pipeline:, destination:, harvest_definitions_to_run:) }

      it { is_expected.to validate_presence_of(:day).with_message("can't be blank") }
    end

    context 'monthly' do
      subject { build(:schedule, frequency: :monthly, pipeline:, destination:, harvest_definitions_to_run:) }

      it { is_expected.to validate_presence_of(:day_of_the_month).with_message("can't be blank") }
    end
  end

  describe '#cron_syntax' do
    context 'daily' do
      it 'returns a valid cron syntax for a minute and hour' do
        schedule = create(:schedule, frequency: 0, time: '12:30', pipeline:, destination:, harvest_definitions_to_run:)

        expect(schedule.cron_syntax).to eq '30 12 * * *'
      end

      it 'returns a valid cron syntax when there is just an hour' do
        schedule = create(:schedule, frequency: 0, time: '12', pipeline:, destination:, harvest_definitions_to_run:)

        expect(schedule.cron_syntax).to eq '0 12 * * *'
      end
    end

    context 'weekly' do
      it 'returns a valid cron syntax for a particular day of the week' do
        schedule = create(:schedule, frequency: 1, day: 3, time: '12:30', pipeline:, destination:, harvest_definitions_to_run:)

        expect(schedule.cron_syntax).to eq '30 12 * * 3' 
      end
    end 

    context 'fortnightly' do
      # TODO
    end
    
    # context 'fornightly' do
    #   pending 'returns a valid cron syntax for a day of the fortnight' do
    #     schedule = create(:schedule, frequency: 2, day: 1, time: '12:30', pipeline:, destination:, harvest_definitions_to_run:)

    #     expect(schedule.cron_syntax).to eq '30 12 * * *'
    #   end
    # end

    context 'monthly' do
      it 'returns a valid cron syntax for a day of the month' do
        schedule = create(:schedule, frequency: 3, fornightly_day_one: 1, fornightly_day_two: 15, time: '12:30', pipeline:, destination:, harvest_definitions_to_run:)

        expect(schedule.cron_syntax).to eq '30 12 21 * *'
      end
    end
  end
end
