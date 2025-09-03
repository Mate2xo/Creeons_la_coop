# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/assign_members_helpers'

RSpec.describe 'admin/missions', type: :request do
  include AssignMembersHelpers
  let(:current_admin) { create(:member, :super_admin) }

  before do
    sign_in current_admin
    allow(DateTime).to receive(:current).and_return DateTime.new(2020, 12, 10, 10)
  end

  describe 'GET /' do
    subject(:index) { get admin_missions_path }

    it 'has an :ok HTTP status' do
      index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /new' do
    subject(:new) { get new_admin_mission_path }

    before { sign_in create :member, :super_admin }

    it 'has a successful HTTP response' do
      new
      expect(response).to have_http_status :success
    end
  end

  describe 'POST /' do
    subject(:post_mission) { post admin_missions_path, params: {mission: mission_params} }

    context 'when the :genre params is set to event' do
      let(:mission_params) { attributes_for(:mission, genre: 'event', author_id: current_admin.id) }

      it 'creates the mission with the genre set to event' do
        post_mission

        expect(Mission.last[:genre]).to eq 'event'
      end
    end

    context 'with invalid params' do
      let(:mission_params) do
        attributes_for(:mission, start_date: DateTime.current, due_date: DateTime.current - 5.minutes)
      end

      it 'sets an error feedback flash' do
        post_mission
        expect(controller.flash[:error]).to be_present
      end
    end
  end

  describe 'GET /:id/edit' do
    subject(:edit) { get edit_admin_mission_path(mission.id) }

    let(:mission) { create(:mission) }

    before { sign_in create :member, :super_admin }

    it 'has a successful HTTP response' do
      edit
      expect(response).to have_http_status :success
    end
  end

  describe 'PUT /:id' do
    subject(:put_mission) { put admin_mission_path(mission.id), params: {mission: mission_params} }

    let(:mission) { create(:mission, start_date: DateTime.current + 2.days) }
    let(:mission_params) do
      attributes_for(:mission,
                     name: 'updated_mission',
                     start_date: mission.start_date + 3.hours,
                     due_date: mission.start_date + 6.hours)
    end

    let!(:expected_params) do
      {name: 'updated_mission', start_date: mission.start_date + 3.hours, due_date: mission.due_date + 3.hours}
    end

    before { allow(DateTime).to receive(:current).and_return DateTime.new(2020, 2, 3, 9) }

    it 'updates the mission' do
      put_mission

      expect(mission.reload.attributes).to include(expected_params.stringify_keys)
    end

    it 'confirms the updates' do
      put_mission
      follow_redirect!

      expect(controller.flash[:notice]).to include(I18n.t('missions.update.confirm_update'))
    end

    context 'when the mission is :regulated and the params standard is passed' do
      let(:mission) { create(:mission, start_date: DateTime.current + 2.days, genre: 'regulated') }

      let(:mission_params) do
        attributes_for(:mission,
                       name: 'updated_mission',
                       start_date: mission.start_date,
                       due_date: mission.due_date,
                       genre: 'standard')
      end

      it 'confirms the update' do
        put_mission
        follow_redirect!

        expect(response.body).to include(I18n.t('missions.update.confirm_update'))
      end

      it 'updates the mission with the params' do
        put_mission
        follow_redirect!

        expect(mission.reload.attributes).to include(mission_params.except(:enrollments).stringify_keys)
      end
    end

    context 'with invalid params' do
      let(:mission_params) do
        attributes_for(:mission, start_date: DateTime.current, due_date: DateTime.current - 5.minutes)
      end

      it 'sets an error feedback flash' do
        put_mission

        expect(controller.flash[:error]).to be_present
      end
    end

    context "when the mission have several enrollments and the datetimes of the related enrollments are outside
    of the new mission's period" do
      let(:mission_params) do
        attributes_for(:mission,
                       name: 'updated_mission',
                       start_date: mission.start_date + 3.hours,
                       due_date: mission.due_date + 3.hours)
      end

      let(:expected_params) { {start_date: mission_params['start_date'], due_date: mission_params['due_date']} }
      let(:i18n_scope) { %i[activerecord errors models mission] }

      it "doesn't update the mission" do
        assign_members_to_this_mission(3, mission)
        put_mission

        expect(mission.reload.name).not_to eq('updated_mission')
      end

      it 'renders a successful response' do
        assign_members_to_this_mission(3, mission)
        put_mission
        expect(response).to be_successful
      end
    end

    context "when the :regulate type is passed in params and the datetimes of the related enrollments
    mismatch the mission's time_slots" do
      let(:mission_params) do
        attributes_for(:mission,
                       name: 'updated_mission',
                       start_date: mission.start_date,
                       due_date: mission.due_date,
                       genre: 'regulated')
      end

      it 'renders a successful response' do
        assign_members_to_this_mission(3, mission, mission.start_date + 1.hour, mission.start_date + 2.hours)

        put_mission

        expect(response).to be_successful
      end

      it "doesn't update the mission" do
        assign_members_to_this_mission(3, mission, mission.start_date + 1.hour, mission.start_date + 2.hours)

        put_mission

        expect(mission.reload.name).not_to eq('updated_mission')
      end
    end

    context "when the mission is :regulate, new datetimes are passed in params and the datetimes of the related
    enrollments mismatch the time_slots of the new mission's period" do
      let(:mission) { create(:mission, start_date: DateTime.current + 2.days, genre: 'regulated') }

      let(:mission_params) do
        attributes_for(:mission,
                       name: 'updated_mission',
                       start_date: mission.start_date - 1.hour,
                       due_date: mission.due_date - 1.hour)
      end

      let(:create_enrollments) do
        create_list(:enrollment,
                    3,
                    start_time: mission.start_date,
                    end_time: mission.start_date + Enrollment::TIME_SLOT_DURATION,
                    member_id: create(:member).id,
                    mission_id: mission.id)
      end

      it 'renders a successful response' do
        assign_members_to_this_mission(3, mission, mission.start_date, mission.start_date + Enrollment::TIME_SLOT_DURATION)

        put_mission

        expect(response).to be_successful
      end

      it "doesn't update the mission" do
        assign_members_to_this_mission(3, mission, mission.start_date, mission.start_date + Enrollment::TIME_SLOT_DURATION)

        put_mission

        expect(mission.reload.name).not_to eq('updated_mission')
      end
    end

    context 'when the recurrent changes params is true' do
      let(:mission_params) do
        attributes_for(:mission,
                       name: 'updated_mission',
                       recurrent_change: true,
                       start_date: mission.start_date + 3.hours,
                       due_date: mission.due_date + 3.hours)
      end

      let(:all_missions) { create_future_matching_missions(mission) + [mission] }
      let!(:expected_start_dates) { all_missions.map(&:start_date) }
      let!(:expected_due_dates) { all_missions.map(&:due_date) }

      it 'updates futures missions that match the same week day, hour, and genre' do
        other_missions = create_future_matching_missions(mission)

        put_mission

        other_missions.each do |mission|
          expect(mission.reload.name).to eq 'updated_mission'
        end
      end

      it "doesn't update pasts missions that match the same week day, hour, and genre" do
        other_mission = create(:mission, start_date: mission.start_date - 2.days)

        put_mission

        expect(other_mission.reload.name).not_to eq 'updated_mission'
      end

      it "doesn't update :start_date attribute" do
        put_mission

        all_missions.each_with_index do |current_mission, index|
          expect(current_mission.reload.start_date).to eq(expected_start_dates[index])
        end
      end

      it "doesn't update :due_date attribute" do
        put_mission

        all_missions.each_with_index do |current_mission, index|
          expect(current_mission.reload.due_date).to eq(expected_due_dates[index])
        end
      end
    end
  end

  # helpers

  def create_history_of_generated_schedule_for_n_months(months_count)
    (1..months_count).each do |n|
      create(:history_of_generated_schedule,
             month_number: (DateTime.current + n.month).at_beginning_of_month)
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
