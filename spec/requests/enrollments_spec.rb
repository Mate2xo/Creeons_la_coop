# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Enrollments', type: :request do
  let(:mission) { create :mission }

  it 'redirects unlogged users' do
    post mission_enrollments_path(mission)
    expect(response).to redirect_to new_member_session_path
  end

  describe 'POST mission_enrollments_path' do
    subject(:post_enrollment) { post mission_enrollments_path(mission), params: params }

    before { sign_in current_member }

    let(:current_member) { create :member }
    let(:enrollment) do
      enrollment = attributes_for :enrollment,
                                  start_time: Time.zone.parse(mission.start_date.to_s),
                                  end_time: Time.zone.parse(mission.due_date.to_s)
      enrollment[:member_id] = current_member.id
      enrollment[:mission_id] = mission.id
      enrollment
    end
    let(:params) { { enrollment: enrollment } }

    it 'creates an enrollment on the given mission' do
      post_enrollment
      expect(mission.reload.enrollments.size).to eq 1
    end

    context 'when the mission is regulated' do
      let(:mission) { create :mission, genre: 'regulated' }
      let(:current_member) { create :member }
      let(:time_slots) { [mission.start_date, mission.start_date + 90.minutes] }
      let(:enrollment) do
        enrollment = attributes_for :enrollment,
                                    time_slots: time_slots,
                                    genre: 'regulated',
                                    start_time: mission.start_date,
                                    end_time: mission.start_date + 3.hours
        enrollment[:member_id] = current_member.id
        enrollment[:mission_id] = mission.id
        enrollment
      end
      let(:params) { { enrollment: enrollment } }

      it 'creates an enrollment on the given mission' do
        post_enrollment
        expect(mission.reload.enrollments.size).to eq 1
      end
    end

    context 'without a member field' do
      it 'enrolls the current_member to the mission' do
        post_enrollment
        expect(Enrollment.last.member_id).to eq current_member.id
      end
    end

    context 'with a given member field' do
      let(:other_member) { create :member }

      it 'enrolls the given member to the mission' do
        enrollment.merge!(member_id: other_member.id)

        post_enrollment

        expect(Enrollment.last.member_id).to eq other_member.id
      end
    end

    context 'with invalid params' do
      let(:params) { { enrollment: { member_id: 0, mission_id: (create :mission).id } } }
      let(:i18n_key) { 'activerecord.errors.models.enrollment.attributes.member.required' }

      it 'displays an error message' do
        post_enrollment

        expect(flash[:alert]).to include(I18n.t(i18n_key))
      end
    end
  end

  describe 'DELETE mission_enrollments_path' do
    subject(:disenroll) { delete mission_enrollments_path(mission, enrollment) }

    before { sign_in current_member }

    let(:current_member) { create :member }
    let(:mission) { create :mission }
    let(:enrollment) { create :enrollment, mission: mission, member: current_member }

    it "deletes the current members' enrollment" do
      disenroll

      expect(Enrollment.where(id: enrollment.id).exists?).to be_falsey
    end
  end
end
