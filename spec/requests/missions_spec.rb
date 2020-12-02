# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/slot_enrollment.rb'

RSpec.configure do |c|
  c.include Helpers::SlotEnrollment
end

RSpec.describe 'A mission request', type: :request do
  let(:member) { create :member }

  before { sign_in member }

  describe 'list of all missions' do
    it 'successfully renders the list' do
      create :mission
      create :mission, event: true

      get missions_path

      expect(response).to be_successful
    end
  end

  describe 'to show an event' do
    it 'renders successfully the template' do
      event = create :mission, event: true

      get mission_path(event.id)

      expect(response).to be_successful
    end

    it 'displays the name of event' do
      event = create :mission, event: true

      get mission_path(event.id)

      expect(response.body).to include(event.name.capitalize)
    end

    context 'when a member participate in an event' do
      it "displays the full name's member" do
        event = create :mission, event: true
        create :participation, event_id: event.id, participant_id: member.id

        get mission_path(event.id)

        expect(response.body).to include("#{member.first_name} #{member.last_name}")
      end
    end
  end

  describe 'for new form of mission model' do
    it 'renders successfully the template' do
      get new_mission_path

      expect(response).to be_successful
    end
  end

  describe 'to create an event' do
    it 'redirect to the show page of this event' do
      event_attributes = attributes_for :mission, event: true

      post missions_path, params: { mission: event_attributes }
      follow_redirect!

      expect(response.body).to include(event_attributes[:name].capitalize)
    end

    it "doesn't create any slots" do
      event_attributes = attributes_for :mission, event: true

      post missions_path, params: { mission: event_attributes }

      expect(Mission.last.slots.size).to eq 0
    end
  end

  describe 'to edit an event' do
    it 'successfully renders the template' do
      event = create :mission, event: true

      get edit_mission_path(event.id), params: { mission: { id: event.attributes[:id] } }

      expect(response).to be_successful
    end
  end

  describe 'to update an event' do
    it 'successfully updates the record' do
      event = create :mission, event: true

      put mission_path(event.id), params: { mission: { name: 'updated_event' } }
      follow_redirect!

      expect(response.body).to include('updated_event'.capitalize)
    end

    context 'when the user request for an event become a mission' do
      it 'creates the slot of the mission' do
        event = create :mission, event: true

        put mission_path(event.id), params: { mission: { name: 'updated_event', event: false } }
        follow_redirect!

        expect(event.slots).not_to be_empty
      end

      it 'redirects to show mission template' do
        event = create :mission, event: true

        put mission_path(event.id), params: { mission: { name: 'updated_event', event: false } }
        follow_redirect!

        expect(response).to render_template(partial: 'missions/_enrollment_form')
      end
    end
  end

  describe 'to delete an event' do
    before do
      sign_in create :member, :super_admin
    end

    it 'deletes the event' do
      event = create :mission, event: true

      delete mission_path(event.id), params: { mission: { id: event.id } }

      expect(Mission.find_by(id: event.id)).to be_nil
    end

    it 'destroy the related participations' do
      event = create :mission, event: true
      participants = create_list :member, 4
      participants.each { |participant| create :participation, event_id: event.id, participant_id: participant.id }

      delete mission_path(event.id), params: { mission: event.attributes }

      expect(Participation.where(event_id: event.id)).to be_empty
    end
  end

  describe 'to show a mission' do
    it 'show the mission successfully' do
      mission = create :mission

      get mission_path(mission.id)

      expect(response).to be_successful
    end

    it 'displays the checkboxes with time slots' do
      mission = create :mission

      get mission_path(mission.id)

      expect(response.body).to include((I18n.t 'missions.enrollment_form.detailled_slot',
                                               start_time: mission.start_date.strftime('%Hh%M'),
                                               end_time: (mission.start_date + 90.minutes).strftime('%Hh%M')))
                           .and include((I18n.t 'missions.enrollment_form.detailled_slot',
                                                start_time: (mission.start_date + 90.minutes).strftime('%Hh%M'),
                                                end_time: (mission.start_date + 180.minutes).strftime('%Hh%M')))
    end

    context 'when a member take a time slot of an mission' do
      it 'displays the full name of this member' do
        mission = create :mission
        mission.slots.first.update(member_id: member.id)

        get mission_path(mission.id)

        expect(response.body).to include("#{member.first_name} #{member.last_name}")
      end
    end

    context 'when the member have already take a time slot' do
      it 'display the related checkbox already checked' do
        mission = create :mission
        mission.slots.first.update(member_id: member.id)

        get mission_path(mission.id)

        expect(response.body).to include "value=\"#{mission.slots.first.start_time}\" checked=\"checked\""
      end

      context 'when all slots of a time slot are taked by others members' do
        it "don't display the related checkbox" do
          mission = create :mission
          generate_enrollments_on_n_time_slots_on_a_mission(mission, 4)

          get mission_path(mission.id)

          expect(response.body).not_to include((I18n.t 'missions.show.detailled_slot',
                                                       start_time: mission.start_date.strftime('%Hh%M'),
                                                       end_time: (mission.start_date + 90.minutes).strftime('%Hh%M')))
        end
      end
    end
  end

  describe 'to create a mission' do
    it 'creates the related beginning slots with the same start time' do
      mission_attributes = attributes_for :mission

      post missions_path, params: { mission: mission_attributes }

      expect(Mission.last.slots.where(start_time: mission_attributes[:start_date]).count).to eq 4
    end

    it 'creates the correct number of slots' do
      mission_attributes = attributes_for :mission

      post missions_path, params: { mission: mission_attributes }

      expect(Mission.last.slots.size).to eq 8
    end

    context 'when the mission is recurrent' do
      let(:generate_recurrent_mission_attributes) do
        attributes_for :mission, start_date: DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 9),
                                 due_date: DateTime.new(DateTime.now.year, DateTime.now.month, DateTime.now.day, 9 + 4.5),
                                 max_member_count: 4, event: false,
                                 recurrent: true,
                                 recurrence_rule: IceCube::Rule.daily.to_json,
                                 recurrence_end_date: DateTime.now + 3.days
      end

      it 'creates the slots for all missions' do
        recurrent_mission_attributes = generate_recurrent_mission_attributes

        post_mission = -> { post missions_path, params: { mission: recurrent_mission_attributes } }

        expect { post_mission.call }.to change { Mission::Slot.count }.by(48)
      end
    end
  end

  describe 'to edit mission' do
    it 'successfully renders the template' do
      mission = create :mission

      get edit_mission_path(mission.id), params: { mission: { id: mission.id } }

      expect(response).to be_successful
    end
  end

  describe 'to update a mission' do
    it 'successfully updates the mission' do
      mission = create :mission

      put mission_path(mission.id), params: { mission: { name: :updated_mission } }
      follow_redirect!

      expect(response.body).to include('updated_mission'.capitalize)
    end

    context 'when a mission must become an event' do
      it 'deletes the slots' do
        mission = create :mission

        put mission_path(mission.id), params: { mission: { name: 'updated_event', event: true } }
        follow_redirect!

        expect(mission.slots).to be_empty
      end

      it 'redirects to show mission template' do
        mission = create :mission

        put mission_path(mission.id), params: { mission: { name: 'updated_event', event: true } }
        follow_redirect!

        expect(response).to render_template(partial: '_participation_form')
      end
    end

    context 'when the duration is extended' do
      it 'adds slots in order to cover the new time slot' do
        mission = create :mission

        put_mission = lambda do
          put mission_path(mission.id), params: { mission: { name: 'updated_event',
                                                             due_date: (mission.due_date + 90.minutes) } }
        end

        expect { put_mission.call }.to change { mission.reload.slots.count }.by(4)
      end
    end

    context 'when the duration is shortened' do
      it 'removes useless slots' do
        mission = create :mission

        put_mission = lambda do
          put mission_path(mission.id), params: { mission: { name: 'updated_event',
                                                             due_date: (mission.due_date - 90.minutes) } }
        end

        expect { put_mission.call }.to change { mission.reload.slots.count }.by(-4)
      end
    end

    context 'when the max_member_count is increased' do
      it 'adds slots in order to cover the new count' do
        mission = create :mission

        put_mission = lambda do
          put mission_path(mission.id), params: { mission: { name: 'updated_event',
                                                             max_member_count: 5 } }
        end

        expect { put_mission.call }.to change { mission.reload.slots.count }.by(2)
      end
    end

    context 'when the max_member_count is reduced' do
      it 'removes useless slots' do
        mission = create :mission

        put_mission = lambda do
          put mission_path(mission.id), params: { mission: { name: 'updated_event',
                                                             max_member_count: 3 } }
        end

        expect { put_mission.call }.to change { mission.reload.slots.count }.by(-2)
      end

      it "doesn't remove when slots are occupied" do
        mission = create :mission
        generate_enrollments_on_n_time_slots_on_a_mission(mission, 4)

        put_mission = lambda do
          put mission_path(mission.id), params: { mission: { name: 'updated_event',
                                                             max_member_count: 3 } }
        end

        expect { put_mission.call }.not_to(change { mission.reload.slots.count })
      end
    end

    context 'when we update the start_date field' do
      it 'updates the start_time of the related slots' do
        mission = create :mission
        old_start_times = mission.slots.map(&:start_time)
        new_start_date = mission.start_date + 7.minutes

        put mission_path(mission.id), params: { mission: { start_date: new_start_date, due_date: mission.due_date + 7.minutes } }
        mission.reload

        old_start_times.each_with_index do |_old_start_time, index|
          expect(mission.slots[index].start_time).to eq old_start_times[index] + 7.minutes
        end
      end
    end
  end

  describe 'to delete a mission' do
    before do
      sign_in create :member, :super_admin
    end

    it 'successfully deletes the mission' do
      mission = create :mission

      delete mission_path(mission.id)

      expect(Mission.find_by(id: mission.id)).to eq nil
    end

    it 'deletes the related slots' do
      mission = create :mission

      delete mission_path(mission.id)

      expect(mission.slots.reload).to be_empty
    end
  end

  def generate_enrollments_on_n_time_slots_on_a_mission(mission, members_count)
    members = create_list :member, members_count
    members.each do |member|
      enroll(mission, member)
    end
  end
end
