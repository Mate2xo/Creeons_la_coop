# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/missions', type: :request do
  before { sign_in create :member }

  describe 'GET / (HTML)' do
    subject(:index) { get missions_path }

    let!(:missions) { create_list(:mission, 2) }

    it 'has an HTTP :OK status' do
      index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET / (JSON)' do
    subject(:index) { get missions_path, as: :json }

    let!(:missions) { create_list(:mission, 2) }

    it 'has an HTTP :OK status' do
      index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /:id' do
    subject(:get_mission) { get mission_path(mission) }

    context 'when the genre is set to standard' do
      let(:mission) { create(:mission) }

      it 'renders the standard partial' do
        get_mission

        expect(response).to render_template('missions/_standard_quick_enrollment_form')
      end
    end

    context 'when the genre is set to regulated' do
      let(:mission) { create(:mission, genre: 'regulated') }

      it 'renders the regulated partial' do
        get_mission

        expect(response).to render_template('missions/_regulated_quick_enrollment_form')
      end
    end
  end

  describe 'POST /' do
    subject(:post_mission) { post missions_path, params: { mission: mission_params } }

    before { sign_in create :member, :super_admin }

    let(:mission_params) { attributes_for(:mission) }

    it 'creates the mission' do
      post_mission

      mission_params.each do |key, value|
        expect(Mission.last.attributes[key.to_s]).to eq value
      end
    end

    context 'when the genre is set to event' do
      let(:mission_params) { attributes_for(:mission, genre: 'event') }

      it 'creates the mission with the specified params' do
        post_mission

        mission_params.each do |key, value|
          expect(Mission.last.attributes[key.to_s]).to eq value
        end
      end
    end

    context 'with invalid params' do
      let(:current_time) { DateTime.current }
      let(:invalid_attributes) do
        attributes_for(:mission, start_date: current_time, due_date: current_time + 2.hours, genre: 'regulated')
      end

      it 'sends an error message when due date is inferior to start_date' do
        invalid_mission_params = attributes_for(:mission, start_date: current_time, due_date: current_time - 5.minutes)

        post missions_path, params: { mission: invalid_mission_params }
        follow_redirect!

        expect(response.body).to include(I18n.t('activerecord.errors.models.mission.attributes.duration.minimum'))
      end

      it 'alert message when duration is superior to ten hours' do
        invalid_mission_params = attributes_for(:mission, start_date: current_time, due_date: current_time + 11.hours)

        post missions_path, params: { mission: invalid_mission_params }
        follow_redirect!

        expect(response.body).to include(I18n.t('activerecord.errors.models.mission.attributes.duration.maximum'))
      end

      it 'sends an error message when mission is regulated and duration is not a multiple of 1.5 hours' do
        invalid_mission_params = invalid_attributes

        post missions_path, params: { mission: invalid_mission_params }
        follow_redirect!

        expect(CGI.unescapeHTML(response.body))
          .to include(I18n.t('activerecord.errors.models.mission.attributes.duration.multiple'))
      end
    end
  end

  describe 'GET /:id/edit' do
    before { sign_in create :member, :super_admin }

    context 'when the mission is not regulated' do
      it 'rends the standards partials' do
        mission = create(:mission)

        get edit_mission_path(mission.id)

        expect(response).to render_template(partial: 'missions/_enrollments_form')
      end
    end

    context 'when the mission is regulated' do
      it 'rends the regulated partials' do
        mission = create(:mission, genre: 'regulated')

        get edit_mission_path(mission.id)

        expect(response).to render_template(partial: 'missions/_enrollment_with_time_slots_fields')
      end
    end
  end

  describe 'PUT /:id' do
    subject(:put_mission) { put mission_path(mission.id), params: { mission: mission_params } }

    let(:mission) { create(:mission) }
    let(:mission_params) { { name: 'updated_mission' } }

    before { sign_in create :member, :super_admin }

    it 'updates the mission' do
      put_mission

      expect(mission.reload.name).to eq 'updated_mission'
    end

    context 'with a regulated mission' do
      let(:mission) { create(:mission, genre: 'regulated') }

      it 'updates the mission' do
        put_mission

        expect(mission.reload.name).to eq 'updated_mission'
      end
    end

    context 'with a regulated mission and when enrollment params are given' do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:member_other_than_the_currently_logged_in_user) { create(:member) }
      let(:enrollment_expected_params) do
        { member_id: member_other_than_the_currently_logged_in_user.id,
          start_time: mission.start_date,
          end_time: mission.start_date + 3.hours }
      end

      let(:enrollment_params) do
        { member_id: member_other_than_the_currently_logged_in_user.id,
          time_slots: [mission.start_date, mission.start_date + 90.minutes] }
      end
      let(:mission_params) do
        { name: 'updated_mission', genre: 'regulated', enrollments_attributes: { '1234': enrollment_params } }
      end

      it 'adds member enrollment' do
        put mission_path(mission.id), params: { mission: mission_params }

        expect(mission.reload.enrollments.first.attributes.symbolize_keys).to include enrollment_expected_params
      end
    end

    context 'with a regulated mission and when a part of time slots is given in enrollment params' do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:member_other_than_the_currently_logged_in_user) { create(:member) }
      let(:enrollment_expected_params) do
        { member_id: member_other_than_the_currently_logged_in_user.id,
          start_time: mission.start_date,
          end_time: mission.start_date + 90.minutes }
      end

      let(:enrollment_params) do
        { member_id: member_other_than_the_currently_logged_in_user.id, time_slots: [mission.start_date] }
      end

      let(:mission_params) do
        { name: 'updated_mission', genre: 'regulated', enrollments_attributes: { '1234': enrollment_params } }
      end

      it 'adds member enrollment' do
        put_mission

        expect(mission.reload.enrollments.first.attributes.symbolize_keys).to include enrollment_expected_params
      end
    end

    context 'when the mission is :regulated and an other :genre is given' do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:mission_params) do
        { name: 'updated_mission', genre: 'standard' }
      end

      it 'updates the mission' do
        put_mission

        expect(mission.reload.genre).to eq 'standard'
      end
    end

    context 'when the mission is :regulated, other :genre is given and enrollments params are given' do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:member_other_than_the_currently_logged_in_user) { create(:member) }
      let(:enrollment_expected_params) do
        { member_id: member_other_than_the_currently_logged_in_user.id,
          start_time: mission.start_date,
          end_time: mission.start_date + 3.hours }
      end

      let(:enrollment_params) do
        { member_id: member_other_than_the_currently_logged_in_user.id,
          time_slots: [mission.start_date, mission.start_date + 90.minutes] }
      end

      let(:mission_params) do
        { name: 'updated_mission', genre: 'standard', enrollments_attributes: { '1234': enrollment_params } }
      end

      it 'updates the mission' do
        put_mission

        expect(mission.reload.genre).to eq 'standard'
      end

      it 'adds member enrollment' do
        put_mission

        expect(mission.reload.enrollments.first.attributes.symbolize_keys).to include enrollment_expected_params
      end
    end

    context 'with :regulated mission and when the destroy params is given for an enrolled member' do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:member_other_than_the_currently_logged_in_user) { create(:member) }
      let(:enrollment) { create(:enrollment, member: member_other_than_the_currently_logged_in_user, mission: mission) }

      let(:enrollment_params) do
        { member_id: member_other_than_the_currently_logged_in_user.id, _destroy: '1', id: enrollment.id }
      end

      let(:mission_params) do
        { name: 'updated_mission', genre: 'regulated', enrollments_attributes: { '0': enrollment_params } }
      end

      it 'disenroll members from mission' do
        put_mission

        expect(mission.members).not_to include(member_other_than_the_currently_logged_in_user)
      end
    end
  end
end
