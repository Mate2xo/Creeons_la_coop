# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'A Mission request', type: :request do
  let(:member) { create :member }

  describe 'Post' do
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

      it 'creates the mission with the related params' do
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

  describe 'GET edit' do
    before { sign_in create :member, :super_admin }

    context 'when the mission is not regulated' do
      it 'rends the standards partials' do
        mission = create :mission

        get edit_mission_path(mission.id)

        expect(response).to render_template(partial: 'missions/_enrollments_form')
      end
    end

    context 'when the mission is regulated' do
      it 'rends the standards partials' do
        mission = create :mission, genre: 'regulated'

        get edit_mission_path(mission.id)

        expect(response).to render_template(partial: 'missions/_enrollments_with_time_slots_form')
      end
    end
  end
end
