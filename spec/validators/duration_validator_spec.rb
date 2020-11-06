# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DurationValidator, type: :model do
  context 'when the mission is not an event' do
    let(:build_mission) do
    end

    it 'invalidates the mission if the duration is not a multiple of 1h30' do
      mission = build :mission, start_date: DateTime.new(2020, 1, 2, 9),
                                due_date: DateTime.new(2020, 1, 2, 9 + 4),
                                max_member_count: 4, event: false

      expect(mission).not_to be_valid
    end

    it 'validates if the duration is a multiple of 1h30' do
      mission = build :mission, start_date: DateTime.new(2020, 1, 2, 9),
                                due_date: DateTime.new(2020, 1, 2, 9 + 4.5),
                                max_member_count: 4, event: false

      expect(mission).to be_valid
    end
  end

  context 'when the mission is an event' do
    it 'validates the mission even if the duration is not a multiple of 1h30' do
      mission = build :mission, start_date: DateTime.new(2020, 1, 2, 9),
                                due_date: DateTime.new(2020, 1, 2, 9 + 4),
                                max_member_count: 4, event: true

      expect(mission).to be_valid
    end
  end
end
