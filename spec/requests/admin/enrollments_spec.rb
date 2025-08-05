# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/assign_members_helpers'

RSpec.describe 'admin/enrollments' do
  include AssignMembersHelpers
  let(:current_admin) { create(:member, :super_admin) }
  let(:member) { create(:member) }

  before { sign_in current_admin }

  describe 'GET /' do
    subject(:index) do
      enrollment = create(:enrollment)
      get admin_mission_enrollments_path(enrollment.mission)
    end

    it 'renders with HTTP success' do
      index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /' do
    subject(:create_enrollment) do
      post admin_mission_enrollments_path(mission.id),
           params: {enrollment: enrollment_params}
    end

    let(:mission) { create(:mission) }
    let(:enrollment_params) do
      attributes_for(:enrollment,
                     start_time: mission.start_date,
                     end_time: mission.due_date,
                     member_id: member.id)
    end

    it 'creates the enrollment' do
      expect { create_enrollment }.to change(Mission, :count).by(1)
    end

    it 'confirms the enrollment creation' do
      create_enrollment
      follow_redirect!

      expect(CGI.unescapeHTML(response.body)).to include(I18n.t('enrollments.create.confirm_enroll'))
    end

    context 'when the related mission is :regulated and the enrollment matches a time slot' do
      let(:mission) { create(:mission, genre: 'regulated') }

      it 'confirms the enrollment creation' do
        create_enrollment
        follow_redirect!

        expect(CGI.unescapeHTML(response.body)).to include(I18n.t('enrollments.create.confirm_enroll'))
      end
    end

    context 'when member is already enrolled' do
      let(:enroll_member) do
        create(:enrollment,
               start_time: mission.start_date,
               end_time: (mission.start_date + Enrollment::TIME_SLOT_DURATION),
               member_id: member.id,
               mission_id: mission.id)
      end

      it 'displays an error message' do
        enroll_member

        create_enrollment

        flash = enroll_member.errors.generate_message(:member, :already_enrolled, name: enroll_member.member.full_name)
        expect(response.body).to include(flash)
      end
    end

    context "when the datetimes of the enrollment aren't inside the mission's period" do
      let(:enrollment_params) do
        attributes_for(:enrollment,
                       start_time: mission.start_date,
                       end_time: (mission.due_date + 3.minutes),
                       member_id: member.id)
      end

      it 'displays an error message' do
        create_enrollment

        expect(response.body).to include(I18n.t('activerecord.errors.models.enrollment.inconsistent_datetimes'))
      end
    end

    context 'when the duration is negative' do
      let(:enrollment_params) do
        attributes_for(:enrollment,
                       start_time: mission.start_date,
                       end_time: (mission.start_date - 3.minutes),
                       member_id: member.id)
      end

      it 'displays an error message' do
        create_enrollment

        expect(response.body).to include(I18n.t('activerecord.errors.models.enrollment.negative_duration'))
      end
    end

    context "when the related mission is regulated and the enrollment's
             datetimes are not matching mission's time_slots" do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:enrollment_params) do
        attributes_for(:enrollment,
                       start_time: mission.start_date + 10.minutes,
                       end_time: (mission.start_date + 100.minutes),
                       member_id: member.id)
      end

      it 'displays an error message' do
        create_enrollment

        expect(response.body).to include(I18n.t('activerecord.errors.models.enrollment.time_slot_mismatch'))
      end
    end

    context "when the related misison is regulated and the enrollment's duration is not a multiple of 90 minutes" do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:enrollment_params) do
        attributes_for(:enrollment,
                       start_time: mission.start_date,
                       end_time: (mission.start_date + 10.minutes),
                       member_id: member.id,
                       mission_id: mission.id)
      end
      let(:i18n_scope) { %i[activerecord errors models enrollment] }

      it 'displays a related error message' do
        create_enrollment

        expect(CGI.unescapeHTML(response.body)).to include(I18n.t('duration_is_not_a_multiple_of_90_minutes',
                                                                  scope: i18n_scope))
      end
    end

    context 'when the mission is :standard and :max_member_count is already reached' do
      let(:mission) { create(:mission, max_member_count: 4) }

      it 'displays an error message' do
        assign_members_to_this_mission(4, mission)

        create_enrollment

        expected_flash = CGI.escape_html I18n.t('activerecord.errors.models.enrollment.attributes.mission.full')
        expect(response.body).to include(expected_flash)
      end
    end

    context 'when the related mission is regulated and the member max_member_count
             is already reached for a :time_slot' do
      let(:mission) { create(:mission, genre: 'regulated', max_member_count: 4) }

      it 'displays an error message' do
        assign_members_to_this_mission(4, mission)

        create_enrollment

        msg = CGI.escape_html I18n.t('activerecord.errors.models.enrollment.attributes.mission.no_slots_available')
        expect(response.body).to include(msg)
      end
    end

    context 'when the related mission is regulated, there is one slot left,
             and the member has an insufficient cash register proficiency' do
      let(:mission) do
        create(:mission,
               genre: 'regulated',
               max_member_count: 4,
               cash_register_proficiency_requirement: 'proficient')
      end

      i18n_key = <<~KEY.strip
        activerecord.errors.models.enrollment.insufficient_cash_register_proficiency
      KEY

      it 'displays an error' do
        assign_members_to_this_mission(3, mission)

        create_enrollment

        expect(CGI.unescapeHTML(response.body)).to include(I18n.t(i18n_key))
      end
    end
  end

  describe 'PUT /:id' do
    subject(:update_enrollment) do
      put admin_mission_enrollment_path(mission.id, enrollment.id),
          params: {enrollment: enrollment_params}
    end

    let(:mission) { create(:mission) }
    let(:enrollment_params) do
      attributes_for(:enrollment,
                     start_time: mission.start_date + 10.minutes,
                     end_time: mission.due_date,
                     member_id: member.id)
    end

    let(:expected_attributes) do
      {
        'start_time' => enrollment_params[:start_time],
        'end_time' => enrollment_params[:end_time],
        'member_id' => enrollment_params[:member_id]
      }
    end

    let(:enrollment) do
      create(:enrollment,
             start_time: mission.start_date,
             end_time: mission.due_date,
             member_id: member.id,
             mission_id: mission.id)
    end

    it 'updates the enrollment' do
      update_enrollment

      expect(enrollment.reload.attributes).to include(expected_attributes)
    end

    it 'confirms the enrollment updates' do
      update_enrollment
      follow_redirect!

      expect(CGI.unescapeHTML(response.body)).to include(I18n.t('enrollments.update.confirm_update'))
    end

    context "when the enrollment's datetimes are outside the mission's period" do
      let(:enrollment_params) do
        attributes_for(:enrollment,
                       start_time: mission.start_date - 10.minutes,
                       end_time: mission.due_date,
                       member_id: member.id)
      end

      it 'displays an error message' do
        update_enrollment

        expect(response.body).to include(I18n.t('activerecord.errors.models.enrollment.inconsistent_datetimes'))
      end
    end

    context 'when the enrollment duration is negative' do
      let(:enrollment_params) do
        attributes_for(:enrollment,
                       start_time: enrollment.end_time,
                       end_time: enrollment.start_time,
                       member_id: member.id)
      end

      it 'displays an error message' do
        update_enrollment

        expect(response.body).to include(I18n.t('activerecord.errors.models.enrollment.negative_duration'))
      end
    end

    context "when the related mission is regulated and the enrollment's
             datetimes are not matching mission's time_slots" do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:enrollment_params) do
        attributes_for(:enrollment,
                       start_time: (enrollment.start_time + 10.minutes),
                       end_time: enrollment.end_time,
                       member_id: member.id)
      end

      it 'displays an error message' do
        update_enrollment

        expect(response.body).to include(I18n.t('activerecord.errors.models.enrollment.time_slot_mismatch'))
      end
    end

    context 'when the related mission is regulated and the :max_member_count
             is already reached for the new time slot' do
      let(:mission) { create(:mission, genre: 'regulated') }

      let(:enrollment) do
        create(:enrollment,
               start_time: mission.start_date,
               end_time: mission.start_date + Enrollment::TIME_SLOT_DURATION,
               mission_id: mission.id)
      end

      let(:enrollment_params) do
        attributes_for(:enrollment,
                       start_time: enrollment.start_time + Enrollment::TIME_SLOT_DURATION,
                       end_time: enrollment.end_time + Enrollment::TIME_SLOT_DURATION,
                       member_id: member.id)
      end
      let(:assign_other_members) do
        assign_members_to_this_mission(4,
                                       mission,
                                       enrollment.start_time + Enrollment::TIME_SLOT_DURATION,
                                       enrollment.end_time + Enrollment::TIME_SLOT_DURATION)
      end

      it 'displays an error message' do
        assign_other_members

        update_enrollment

        msg = CGI.escape_html I18n.t('activerecord.errors.models.enrollment.attributes.mission.no_slots_available')
        expect(response.body).to include(msg)
      end
    end

    context 'when the related mission is regulated and the member has an
             insufficient cash register proficiency for the new time slot' do
      let(:mission) { create(:mission, genre: 'regulated', cash_register_proficiency_requirement: 'proficient') }
      let(:enrollment) do
        create(:enrollment,
               start_time: mission.start_date,
               end_time: mission.start_date + Enrollment::TIME_SLOT_DURATION,
               mission_id: mission.id)
      end
      let(:enrollment_params) do
        attributes_for(:enrollment,
                       start_time: enrollment.start_time + Enrollment::TIME_SLOT_DURATION,
                       end_time: enrollment.end_time + Enrollment::TIME_SLOT_DURATION,
                       member_id: member.id)
      end

      i18n_key = <<~KEY.strip
        activerecord.errors.models.enrollment.insufficient_cash_register_proficiency
      KEY

      it 'displays an error message' do
        assign_members_to_this_mission(2, mission)
        assign_members_to_this_mission(1, mission, mission.start_date + Enrollment::TIME_SLOT_DURATION)

        update_enrollment

        expect(CGI.unescapeHTML(response.body)).to include(I18n.t(i18n_key))
      end
    end
  end
end
