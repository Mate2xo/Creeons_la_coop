# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Missions::RecurrentUpdateTransaction do
  subject(:transaction) { described_class.new.call(params:, old_mission: mission) }

  context 'with a falsy :recurrent_change param' do
    let(:params) do
      ActionController::Parameters.new(
        {
          'name' => 'updated_mission',
          'start_date(1i)' => mission.start_date.year.to_s,
          'start_date(2i)' => mission.start_date.month.to_s,
          'start_date(3i)' => mission.start_date.day.to_s,
          'start_date(4i)' => (mission.start_date.hour + 3).to_s,
          'start_date(5i)' => mission.start_date.min.to_s,
          'due_date(1i)' => mission.due_date.year.to_s,
          'due_date(2i)' => mission.due_date.month.to_s,
          'due_date(3i)' => mission.due_date.day.to_s,
          'due_date(4i)' => (mission.due_date.hour + 3).to_s,
          'due_date(5i)' => mission.due_date.min.to_s,
          'recurrent_change' => '0'
        }
      ).permit!
    end

    let(:mission) { create(:mission, recurrent: true) }

    it 'does not update futures missions that match the same week day, hour, and genre' do
      other_missions = create_future_missions_with_matching_time_and_weekday(mission)

      transaction

      other_missions.each do |mission|
        expect(mission.reload.name).not_to eq 'updated_mission'
      end
    end

    it "updates the given mission's attributes" do
      expect { transaction }.to(change { mission.reload.name })
    end

    it "updates the given mission's :start_date and :due_date" do
      expect { transaction }.to change { mission.reload.start_date }
        .and(change { mission.reload.due_date })
    end
  end

  context 'with a truthy :recurrent_change param' do
    let(:params) do
      ActionController::Parameters.new(
        {
          'name' => 'updated_mission',
          'start_date(1i)' => mission.start_date.year.to_s,
          'start_date(2i)' => mission.start_date.month.to_s,
          'start_date(3i)' => mission.start_date.day.to_s,
          'start_date(4i)' => (mission.start_date.hour + 3).to_s,
          'start_date(5i)' => mission.start_date.min.to_s,
          'due_date(1i)' => mission.due_date.year.to_s,
          'due_date(2i)' => mission.due_date.month.to_s,
          'due_date(3i)' => mission.due_date.day.to_s,
          'due_date(4i)' => (mission.due_date.hour + 3).to_s,
          'due_date(5i)' => mission.due_date.min.to_s,
          'recurrent_change' => '1'
        }
      ).permit!
    end

    let(:mission) { create(:mission, recurrent: true) }

    it 'updates futures missions that match the same week day, hour, and genre' do
      other_missions = create_future_missions_with_matching_time_and_weekday(mission)

      transaction

      other_missions.each do |mission|
        expect(mission.reload.name).to eq 'updated_mission'
      end
    end

    it "doesn't update pasts missions that match the same week day, hour, and genre" do
      other_mission = create(:mission, start_date: mission.start_date - 2.days)

      transaction

      expect(other_mission.reload.name).not_to eq 'updated_mission'
    end

    it "doesn't update any :start_date attribute" do
      other_missions = create_future_missions_with_matching_time_and_weekday(mission)
      original_start_dates = other_missions.map(&:start_date)

      transaction

      other_missions.each(&:reload)
      expect(other_missions.pluck(:start_date)).to eq original_start_dates
    end

    it "doesn't update any :due_date attribute" do
      other_missions = create_future_missions_with_matching_time_and_weekday(mission)
      original_due_dates = other_missions.map(&:due_date)

      transaction

      other_missions.each(&:reload)
      expect(other_missions.pluck(:due_date)).to eq original_due_dates
    end
  end

  context 'with a truthy :recurrent_change param and a non-recurrent Mission' do
    let(:params) do
      ActionController::Parameters.new(
        {
          'name' => 'updated_mission',
          'start_date(1i)' => mission.start_date.year.to_s,
          'start_date(2i)' => mission.start_date.month.to_s,
          'start_date(3i)' => mission.start_date.day.to_s,
          'start_date(4i)' => (mission.start_date.hour + 3).to_s,
          'start_date(5i)' => mission.start_date.min.to_s,
          'due_date(1i)' => mission.due_date.year.to_s,
          'due_date(2i)' => mission.due_date.month.to_s,
          'due_date(3i)' => mission.due_date.day.to_s,
          'due_date(4i)' => (mission.due_date.hour + 3).to_s,
          'due_date(5i)' => mission.due_date.min.to_s,
          'recurrent_change' => '1'
        }
      ).permit!
    end

    let(:mission) { create(:mission, recurrent: false) }

    it 'does not update futures missions that match the same week day, hour, and genre' do
      other_missions = create_future_missions_with_matching_time_and_weekday(mission)

      transaction

      other_missions.each do |mission|
        expect(mission.reload.name).not_to eq 'updated_mission'
      end
    end
  end
end

def create_future_missions_with_matching_time_and_weekday(mission)
  occurrence_date = mission.start_date + 7.days
  other_missions = []
  4.times do
    other_missions << create(:mission, start_date: occurrence_date, genre: mission.genre, recurrent: mission.recurrent)
    occurrence_date += 7.days
  end
  other_missions
end
