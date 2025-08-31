# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Missions::UpdateTransaction do
  subject(:update) do
    described_class.new.with_step_args(
      transform_time_slots_in_time_params_for_enrollment: [regulated: mission.regulated?],
      update: [mission: mission]
    ).call(controller_params)
  end

  let(:controller_params) { ActionController::Parameters.new({name: 'updated mission'}).permit :name }

  context 'with a regulated mission' do
    let(:mission) { create(:mission, :regulated) }

    it 'updates the mission' do
      update

      expect(mission.reload.name).to eq 'updated mission'
    end

    context 'when enrollment params are given for the whole duration of the mission' do
      let(:controller_params) do
        ActionController::Parameters
          .new({
                 name: 'updated mission',
                 enrollments_attributes: {
                   '0': {time_slots: [mission.start_date, mission.start_date + Enrollment::TIME_SLOT_DURATION],
                         member_id: create(:member).id}
                 }
               })
          .permit(:name, enrollments_attributes: [:id, :_destroy, :member_id, {time_slots: []}])
      end

      it 'adds this enrollment on the mission', :aggregate_failures do
        expect { update }.to change(Enrollment, :count).by 1

        enrollment_expected_attributes = {start_time: mission.start_date,
                                          end_time: mission.start_date + 3.hours}
        expect(mission.reload.enrollments.first.attributes.symbolize_keys).to include enrollment_expected_attributes
      end
    end

    context 'when enrollment params are given for part of the duration of the mission' do
      let(:controller_params) do
        ActionController::Parameters
          .new({
                 name: 'updated mission',
                 enrollments_attributes: {
                   '0': {time_slots: [mission.start_date],
                         member_id: create(:member).id}
                 }
               })
          .permit(:name, enrollments_attributes: [:id, :_destroy, :member_id, {time_slots: []}])
      end

      it 'adds this enrollment on the mission', :aggregate_failures do
        expect { update }.to change(Enrollment, :count).by 1

        enrollment_expected_attributes = {start_time: mission.start_date,
                                          end_time: mission.start_date + Enrollment::TIME_SLOT_DURATION}
        expect(mission.reload.enrollments.first.attributes.symbolize_keys).to include enrollment_expected_attributes
      end
    end

    context 'when an other :genre is given' do
      let(:controller_params) do
        ActionController::Parameters
          .new({name: 'updated mission', genre: :standard})
          .permit :name, :genre
      end

      it "updates the mission's genre" do
        update

        expect(mission).to be_standard
      end
    end

    context 'when destroy params are given for an enrolled member' do
      let(:controller_params) do
        member = create(:member)
        existing_enrollment = create(:enrollment, member:, mission:) { mission.reload }
        ActionController::Parameters
          .new({
                 name: 'updated mission',
                 enrollments_attributes: {
                   '0': {_destroy: '1', id: existing_enrollment.id, member_id: member.id}
                 }
               })
          .permit(:name, enrollments_attributes: [:id, :_destroy, :member_id, {time_slots: []}])
      end

      it 'disenroll the member from mission' do
        update
        expect(mission.members).to be_empty
      end
    end
  end

  context 'with a standard mission' do
    let(:mission) { create(:mission) }

    it 'updates the mission' do
      update

      expect(mission.reload.name).to eq 'updated mission'
    end
  end
end
