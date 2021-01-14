# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'A Missions admin request', type: :request do
  let(:current_admin) { create :member, :super_admin }

  before { sign_in current_admin }

  describe '#generate_schedule' do
    subject(:post_generate_schedule) { post generate_schedule_admin_missions_path(3) }

    before do
      allow(DateTime).to receive(:current).and_return DateTime.new(2020, 12, 10)
    end

    context 'when all schedules asked has been already generated' do
      it 'notices that the schedule has already been generated' do
        create_history_of_generated_schedule_for_n_months(3)
        post_generate_schedule
        follow_redirect!

        expect(response.body).to include(I18n.t('admin.missions.generate_schedule.schedule_already_generated'))
      end
    end
  end

  describe 'POST' do
    subject(:post_mission) { post admin_missions_path, params: { mission: mission_params } }

    context 'when the :genre params is set to event' do
      let(:mission_params) { attributes_for :mission, genre: 'event', author_id: current_admin.id }

      it 'creates the mission with the genre setted to event' do
        post_mission

        expect(Mission.last[:genre]).to eq 'event'
      end
    end
  end

  describe 'PUT' do
    subject(:put_mission) { put admin_mission_path(updated_mission.id), params: { mission: mission_params } }

    before { allow(DateTime).to receive(:current).and_return DateTime.new(2020, 2, 3, 9) }

    context 'when the recurrent changes params is true' do
      let(:updated_mission) { create :mission, start_date: DateTime.current + 2.days }
      let(:mission_params) do
        { name: 'updated_mission',
          recurrent_change: true,
          start_date: updated_mission.start_date + 3.hours,
          due_date: updated_mission.due_date + 3.hours }
      end

      it 'updates futures missions that match the same week day, hour, and genre' do # rubocop:disable Layout/LineLength
        other_missions = create_future_matching_missions(updated_mission)

        put_mission

        other_missions.each do |mission|
          expect(mission.reload.name).to eq 'updated_mission'
        end
      end

      it "doesn't update pasts missions that match the same week day, hour, and genre" do # rubocop:disable Layout/LineLength
        other_mission = create :mission, start_date: updated_mission.start_date - 2.days

        put_mission

        expect(other_mission.reload.name).not_to eq 'updated_mission'
      end

      it "doesn't update :start_date attribute" do
        expect { put_mission }.not_to change(updated_mission, :start_date)
      end

      it "doesn't update :due_date attribute" do
        expect { put_mission }.not_to change(updated_mission, :due_date)
      end
    end
  end

  # helpers

  def create_history_of_generated_schedule_for_n_months(months_count)
    (1..months_count).each do |n|
      create :history_of_generated_schedule,
             month_number: (DateTime.current + n.month).at_beginning_of_month
    end
  end

  def create_future_matching_missions(mission)
    occurrence_date = mission.start_date + 7.days
    other_missions = []
    4.times do
      other_missions << create(:mission, start_date: occurrence_date, genre: mission.genre)
      occurrence_date += 7.days
    end
    other_missions
  end
end
