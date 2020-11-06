# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'A mission request', type: :request do
  let(:super_admin) { create :member, :super_admin }

  let(:generate_event_attributes) do
    attributes_for :mission, name: 'my event',
                             max_member_count: 4, event: true
  end

  let(:generate_mission_attributes) do
    attributes_for :mission, name: 'my_mission',
                             max_member_count: 4, event: false
  end

  let(:create_event) { create :mission, generate_event_attributes }
  let(:create_mission) { create :mission, generate_mission_attributes }
  let(:create_mission_with_slots) { create :mission, generate_mission_attributes.merge({ with_slots: true }) }

  before { sign_in super_admin }

  describe 'list of all missions' do
    it 'successfully renders the list' do
      create_event
      create_mission

      get missions_path

      expect(response).to be_successful
    end
  end

  describe 'to show an event' do
    it 'renders successfully the template' do
      event = create_event

      get mission_path(event.id)

      expect(response).to be_successful
    end

    it 'displays the name of event' do
      event = create_event

      get mission_path(event.id)

      expect(response.body).to include(event.name.capitalize)
    end

    context 'when a member particpate in an event' do
      it "displays the full name's member" do
        event = create_event
        create :participation, event_id: event.id, participant_id: super_admin.id

        get mission_path(event.id)

        expect(response.body).to include("#{super_admin.first_name} #{super_admin.last_name}")
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
      event_attributes = generate_event_attributes

      post missions_path, params: { mission: event_attributes }
      follow_redirect!

      expect(response.body).to include(event_attributes[:name].capitalize)
    end

    it "doesn't create any slots" do
      post missions_path, params: { mission: generate_event_attributes }

      expect(Mission.last.slots.size).to eq 0
    end
  end

  describe 'to edit an event' do
    it 'successfully renders the template' do
      event = create_event

      get edit_mission_path(event.id), params: { mission: { id: event.id } }

      expect(response).to be_successful
    end
  end

  describe 'to update an event' do
    it 'successfully updates the record' do
      event = create_event

      put mission_path(event.id), params: { mission: { name: 'updated_event' } }
      follow_redirect!

      expect(response.body).to include('updated_event'.capitalize)
    end
  end

  describe 'to delete an event' do
    it 'delete the event' do
      event = create_event

      delete mission_path(event.id), params: { mission: { id: event.id } }

      expect(Mission.find_by(id: event.id)).to be_nil
    end

    it 'destroy the related participations' do
      event = create_event
      participants = create_list :member, 4
      participants.each { |participant| create :participation, event_id: event.id, participant_id: participant.id }

      delete mission_path(event.id), params: { mission: event.attributes }

      expect(Participation.where(event_id: event.id)).to be_empty
    end
  end

  describe 'to show a mission' do
    it 'show the mission successfully' do
      mission = create_mission_with_slots

      get mission_path(mission.id)

      expect(response).to be_successful
    end

    it 'displays the checkboxes with time slots' do
      mission = create_mission_with_slots

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
        mission = create_mission_with_slots
        mission.slots.first.update(member_id: super_admin.id)

        get mission_path(mission.id)

        expect(response.body).to include("#{super_admin.first_name} #{super_admin.last_name}")
      end
    end

    context 'when the member have already take a time slot' do
      it 'display the related checkbox already checked' do
        mission = create_mission_with_slots
        mission.slots.first.update(member_id: super_admin.id)

        get mission_path(mission.id)

        expect(response.body).to include "value=\"#{mission.slots.first.start_time}\" checked=\"checked\""
      end

      context 'when all slots of a time slot are taked by others members' do
        it "don't display the related checkbox" do
          mission = create_mission_with_slots
          members = create_list :member, 4
          members.each do |member|
            mission.slots.find_by(start_time: mission.start_date, member_id: nil).update(member_id: member.id)
          end

          get mission_path(mission.id)

          expect(response.body).not_to include((I18n.t 'missions.show.detailled_slot',
                                                       start_time: mission.start_date.strftime('%Hh%M'),
                                                       end_time: (mission.start_date + 90.minutes).strftime('%Hh%M')))
        end
      end
    end
  end

  describe 'to create a mission' do
    it 'create the related beginning slots with the same start time' do
      mission_attributes = generate_mission_attributes

      post missions_path, params: { mission: mission_attributes }

      expect(Mission.last.slots.where(start_time: mission_attributes[:start_date]).count).to eq 4
    end

    it 'create the correct number of slots' do
      mission_attributes = generate_mission_attributes

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

      it 'create the slots for all missions' do
        recurrent_mission_attributes = generate_recurrent_mission_attributes

        post_mission = -> { post missions_path, params: { mission: recurrent_mission_attributes } }

        expect { post_mission.call }.to change { Mission::Slot.count }.by(48)
      end
    end
  end

  describe 'to edit mission' do
    it 'successfully renders the template' do
      mission = create_mission

      get edit_mission_path(mission.id), params: { mission: { id: mission.id } }

      expect(response).to be_successful
    end
  end

  describe 'to update a mission' do
    it 'successfully updates the mission' do
      mission = create_mission_with_slots

      put mission_path(mission.id), params: { mission: { name: :updated_mission } }
      follow_redirect!

      expect(response.body).to include('updated_mission'.capitalize)
    end

    context 'when we update the start_date field' do
      it 'updates the start_time of the related slots' do
        mission = create_mission_with_slots
        old_start_times = mission.slots.map(&:start_time)
        new_start_date = mission.start_date + 7.minutes

        put mission_path(mission.id), params: { mission: { start_date: new_start_date, due_date: new_start_date + 90.minutes } }
        mission.reload

        old_start_times.each_with_index do |_old_start_time, index|
          expect(mission.slots[index].start_time).to eq old_start_times[index] + 7.minutes
        end
      end
    end

    context 'when we try to update the event boolean' do
      it "doesn't update the field" do
        mission = create_mission

        put_mission = -> { put mission_path(mission.id), params: { mission: { event?: true } } }

        expect { put_mission.call }.not_to(change { mission.event })
      end
    end
  end

  describe 'to deletes a mission' do
    it 'successfully deletes the mission' do
      mission_id = create_mission.id

      delete mission_path(mission_id)

      expect(Mission.find_by(id: mission_id)).to eq nil
    end

    it 'deletes the related slots' do
      mission = create_mission_with_slots

      delete mission_path(mission.id)

      expect(mission.slots.reload).to be_empty
    end
  end
end
