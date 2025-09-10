# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/assign_members_helpers'

RSpec.describe 'admin/missions' do
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
  end

  # helpers

  def create_history_of_generated_schedule_for_n_months(months_count)
    (1..months_count).each do |n|
      create(:history_of_generated_schedule,
             month_number: (DateTime.current + n.month).at_beginning_of_month)
    end
  end
end
