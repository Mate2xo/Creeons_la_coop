# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleGenerator, type: :model do
  describe '#generate_schedule' do
    subject(:generate_schedule) { ScheduleGenerator.new(author).generate_schedule }

    let(:author) { create :member }

    before { allow(DateTime).to receive(:current).and_return DateTime.new(2020, 12, 10) }

    it 'generates three missions for each working days of the next month ' do
      expect { generate_schedule }.to change(Mission, :count).by(78)
    end
  end
end
