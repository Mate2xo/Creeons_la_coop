require 'rails_helper'

RSpec.describe GenerateScheduleJob do
  include ActiveJob::TestHelper

  subject(:generate_job) do
    described_class.perform_later(current_member: current_member, current_month: current_month.to_s)
  end

  let(:current_member) { create(:member) }
  let(:current_month) { Date.new(2024, 12, 27).beginning_of_month }

  it 'launches the ScheduleGenerator service' do
    generator_double = instance_double(ScheduleGenerator, generate_schedule: nil, errors: [])
    allow(ScheduleGenerator).to receive(:new).and_return(generator_double)

    perform_enqueued_jobs { generate_job }

    expect(generator_double).to have_received(:generate_schedule)
  end

  it 'creates Missions for the given month' do
    expect { perform_enqueued_jobs { generate_job } }.to change(Mission, :count).from(0).to(78)
  end

  it 'creates HistoryOfGeneratedSchedule for the given month' do
    expect { perform_enqueued_jobs { generate_job } }.to change(HistoryOfGeneratedSchedule, :count).from(0).to(1)
  end

  context 'when the schedule genreration encountered some errors' do
    before do
      generator_double = instance_double(ScheduleGenerator, generate_schedule: nil, errors: ['BOOM'])
      allow(ScheduleGenerator).to receive(:new).and_return(generator_double)
    end

    it 'returns without creating any schedule generation history' do
      expect { perform_enqueued_jobs { generate_job } }.not_to change(HistoryOfGeneratedSchedule, :count).from(0)
    end
  end
end
