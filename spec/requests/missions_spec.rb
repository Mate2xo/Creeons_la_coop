# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/slot_enrollment.rb'

RSpec.configure do |c|
  c.include Helpers::SlotEnrollment
end

RSpec.describe 'A Mission request', type: :request do
  let(:member) { create :member }

  before { sign_in member }

  describe 'GET index' do
    subject(:get_index) { get missions_path }

    it 'successfully renders the list' do
      create :mission
      create :mission, event: true

      get_index

      expect(response).to be_successful
    end
  end

  describe 'GET show' do
    subject(:get_show) { get mission_path(mission) }

    context 'when the mission is an :event' do
      let(:mission) { create :mission, event: true }

      it 'renders successfully the template' do
        get_show

        expect(response).to be_successful
      end

      it 'displays the name of event' do
        get_show

        expect(response.body).to include(mission.name.capitalize)
      end

      it "displays the full name's member when in an event" do
        create :participation, event_id: mission.id, participant_id: member.id

        get_show

        expect(response.body).to include("#{member.first_name} #{member.last_name}")
      end
    end

    context 'when the mission is not an :event' do
      let(:mission) { create :mission }
      let(:i18n_call) do
        I18n.t 'missions.enrollment_form.detailled_slot',
               start_time: mission.start_date.strftime('%Hh%M'),
               end_time: (mission.start_date + 90.minutes).strftime('%Hh%M')
      end

      let(:i18n_call2) do
        I18n.t 'missions.enrollment_form.detailled_slot',
               start_time: (mission.start_date + 90.minutes).strftime('%Hh%M'),
               end_time: (mission.start_date + 180.minutes).strftime('%Hh%M')
      end

      it 'show the mission successfully' do
        get_show

        expect(response).to be_successful
      end

      it 'displays the checkboxes with time slots' do
        get_show

        expect(response.body).to include(i18n_call).and include(i18n_call2)
      end

      it 'displays the full name of members who are enrolled in mission' do
        mission.slots.first.update(member_id: member.id)

        get_show

        expect(response.body).to include("#{member.first_name} #{member.last_name}")
      end

      context 'when the time slots are already taked' do # rubocop:disable Layout/NestedGroups
        it 'display the related checkbox already taked by current member' do
          mission.slots.first.update(member_id: member.id)

          get_show

          expect(response.body).to include "value=\"#{mission.slots.first.start_time}\" checked=\"checked\""
        end

        it 'displays an unavailability message when all slots had been taked by others members' do
          generate_enrollments_on_n_time_slots_on_a_mission(mission, 4)

          get_show

          expect(response.body).not_to include I18n.t('missions.enrollment_form.unavailability')
        end
      end
    end
  end

  describe 'GET new' do
    it 'renders successfully the template' do
      get new_mission_path

      expect(response).to be_successful
    end
  end

  describe 'Post' do
    subject(:post_mission) { post missions_path, params: params }

    context 'when the mission is an :event' do
      let(:params) { { mission: attributes_for(:mission, event: true) } }

      it 'redirect to the show page of this event' do
        post_mission
        follow_redirect!

        expect(response.body).to include(params[:mission][:name].capitalize)
      end

      it "doesn't create any slots" do
        post_mission

        expect(Mission.last.slots.size).to eq 0
      end
    end

    context 'when the mission is not an :event' do
      let(:params) { { mission: attributes_for(:mission) } }

      it 'creates the related beginning slots with the same start time' do
        post_mission

        expect(Mission.last.slots.where(start_time: params[:mission][:start_date]).count).to eq 4
      end

      it 'creates the correct number of slots' do
        post_mission

        expect(Mission.last.slots.size).to eq 8
      end

      context 'when the mission is recurrent' do # rubocop:disable Layout/NestedGroups
        let(:params) do
          { mission: attributes_for(:mission, start_date: DateTime.new(DateTime.now.year,
                                                                       DateTime.now.month,
                                                                       DateTime.now.day, 9),
                                              due_date: DateTime.new(DateTime.now.year,
                                                                     DateTime.now.month,
                                                                     DateTime.now.day, 9 + 4.5),
                                              max_member_count: 4, event: false,
                                              recurrent: true,
                                              recurrence_rule: IceCube::Rule.daily.to_json,
                                              recurrence_end_date: DateTime.now + 3.days) }
        end

        it 'creates the slots for all missions' do
          lambda_post_mission = -> { post_mission }

          expect { lambda_post_mission.call }.to change { Mission::Slot.count }.by(48)
        end
      end

      context 'when the params are invalids' do # rubocop:disable Layout/NestedGroups
        it 'warns on duration multiple when duration is not a multiple of 90 minutes' do
          mission_attributes = attributes_for :mission, start_date: DateTime.current,
                                                        due_date: DateTime.current + 100.minutes

          post missions_path, params: { mission: mission_attributes }
          follow_redirect!

          expect(response.body).to include(I18n.t('activerecord.errors.models.mission.attributes.duration.multiple'))
        end

        it "warns on minimum's duration when the duration is too short" do
          mission_attributes = attributes_for :mission, start_date: DateTime.current,
                                                        due_date: DateTime.current

          post missions_path, params: { mission: mission_attributes }
          follow_redirect!

          expect(response.body).to include(I18n.t('activerecord.errors.models.mission.attributes.duration.minimum'))
        end

        it "warns on extends's duration when the duration is too large" do
          mission_attributes = attributes_for :mission, start_date: DateTime.current,
                                                        due_date: DateTime.current + 900.minutes

          post missions_path, params: { mission: mission_attributes }
          follow_redirect!

          expect(response.body).to include(I18n.t('activerecord.errors.models.mission.attributes.duration.extend'))
        end
      end
    end
  end

  describe 'GET edit' do
    subject(:get_edit) { get edit_mission_path(mission.id), params: { mission: mission.attributes } }

    context 'when the mission is an :event' do
      let(:mission) { create :mission, event: true }

      it 'has a successful response' do
        get_edit

        expect(response).to be_successful
      end
    end

    context 'when the mission is not an :event' do
      let(:mission) { create :mission }

      it 'has a successful response' do
        get_edit

        expect(response).to be_successful
      end
    end
  end

  describe 'update' do
    subject(:update_mission) { put mission_path(mission.id), params: params }

    context 'when the mission is an :event' do
      let(:mission) { create :mission, event: true }
      let(:params) { { mission: { name: 'updated_event' } } }

      it 'successfully updates the record' do
        update_mission
        follow_redirect!

        expect(response.body).to include('updated_event'.capitalize)
      end

      context 'when the user request for an event become a mission' do # rubocop:disable Layout/NestedGroups
        let(:params) { { mission: { name: 'updated_event', event: false } } }

        it 'creates the slot of the mission' do
          update_mission
          follow_redirect!

          expect(mission.slots).not_to be_empty
        end

        it 'redirects to show mission template' do
          update_mission
          follow_redirect!

          expect(response).to render_template(partial: 'missions/_enrollment_form')
        end
      end
    end

    context 'when the mission is not an :event' do
      let(:mission) { create :mission }
      let(:params) { { mission: { name: 'updated_mission' } } }

      it 'successfully updates the mission' do
        update_mission
        follow_redirect!

        expect(response.body).to include('updated_mission'.capitalize)
      end

      context 'when a mission must become an event' do # rubocop:disable Layout/NestedGroups
        let(:params) { { mission: { name: 'update_mission', event: true } } }

        it 'deletes the slots' do
          update_mission
          follow_redirect!

          expect(mission.slots).to be_empty
        end

        it 'redirects to show mission template' do
          update_mission
          follow_redirect!

          expect(response).to render_template(partial: '_participation_form')
        end
      end

      context 'when the duration is extended' do # rubocop:disable Layout/NestedGroups
        let(:params) { { mission: { name: 'updated_event', due_date: (mission.due_date + 90.minutes) } } }

        it 'adds slots in order to cover the new time slot' do
          put_mission = -> { update_mission }

          expect { put_mission.call }.to change { mission.reload.slots.count }.by(4)
        end
      end

      context 'when the duration is shortened' do # rubocop:disable Layout/NestedGroups
        let(:params) { { mission: { name: 'updated_event', due_date: (mission.due_date - 90.minutes) } } }

        it 'removes useless slots' do
          put_mission = -> { update_mission }

          expect { put_mission.call }.to change { mission.reload.slots.count }.by(-4)
        end
      end

      context 'when the max_member_count is increased' do # rubocop:disable Layout/NestedGroups
        let(:params) { { mission: { name: 'updated_event', max_member_count: 5 } } }

        it 'adds slots in order to cover the new count' do
          put_mission = -> { update_mission }

          expect { put_mission.call }.to change { mission.reload.slots.count }.by(2)
        end
      end

      context 'when the max_member_count is reduced' do # rubocop:disable Layout/NestedGroups
        let(:params) { { mission: { name: 'updated_event', max_member_count: 3 } } }

        it 'removes useless slots' do
          put_mission = -> { update_mission }

          expect { put_mission.call }.to change { mission.reload.slots.count }.by(-2)
        end

        it "doesn't remove when slots are occupied" do
          generate_enrollments_on_n_time_slots_on_a_mission(mission, 4)

          put_mission = -> { update_mission }

          expect { put_mission.call }.not_to(change { mission.reload.slots.count })
        end
      end

      context 'when we update the start_date field' do # rubocop:disable Layout/NestedGroups
        let(:new_start_date) { mission.start_date + 7.minutes }
        let(:params) { { mission: { start_date: new_start_date, due_date: mission.due_date + 7.minutes } } }

        it 'updates the start_time of the related slots' do
          update_mission
          mission.reload

          expect(mission.slots.group(:start_time).count.keys).to include(new_start_date, new_start_date + 90.minutes)
            .and have_attributes(count: 2)
        end
      end
    end
  end

  describe 'delete' do
    subject(:delete_mission) { delete mission_path(mission.id), params: { mission: { id: mission.id } } }

    before do
      sign_in create :member, :super_admin
    end

    context 'when the mission is an :event' do
      let(:mission) { create :mission, event: true }

      it 'deletes the event' do
        delete_mission

        expect(Mission.find_by(id: mission.id)).to be_nil
      end

      it 'destroy the related participations' do
        participants = create_list :member, 4
        participants.each { |participant| create :participation, event_id: mission.id, participant_id: participant.id }

        delete_mission

        expect(Participation.where(event_id: mission.id)).to be_empty
      end
    end

    context 'when the is not an :event' do
      let(:mission) { create :mission }

      it 'successfully deletes the mission' do
        delete_mission

        expect(Mission.find_by(id: mission.id)).to eq nil
      end

      it 'deletes the related slots' do
        delete_mission

        expect(mission.slots.reload).to be_empty
      end
    end
  end

  def generate_enrollments_on_n_time_slots_on_a_mission(mission, members_count)
    members = create_list :member, members_count
    members.each do |member|
      enroll(mission, member)
    end
  end
end
