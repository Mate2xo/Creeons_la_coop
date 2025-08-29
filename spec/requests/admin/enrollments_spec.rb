# frozen_string_literal: true

require 'rails_helper'
require 'support/helpers/assign_members_helpers'

RSpec.describe 'admin/enrollments' do
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

      expect(controller.flash[:notice]).to eq I18n.t('enrollments.create.confirm_enroll')
    end

    context 'with a :regulated mission and an enrollment matching a time slot' do
      let(:mission) { create(:mission, genre: :regulated) }

      it 'confirms the enrollment creation' do
        create_enrollment
        follow_redirect!

        expect(controller.flash[:notice]).to eq I18n.t('enrollments.create.confirm_enroll')
      end
    end

    context 'with an invalid enrollment' do
      let(:mission) { create(:mission, max_member_count: 4, with_enrollments: 4) } # already full

      it 'displays an error flash' do
        create_enrollment
        expect(controller.flash[:error]).to eq I18n.t('activerecord.errors.models.enrollment.attributes.mission.full')
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
    let(:enrollment) do
      create(:enrollment,
             start_time: mission.start_date,
             end_time: mission.due_date,
             member_id: member.id,
             mission_id: mission.id)
    end

    it 'updates the enrollment' do
      update_enrollment

      expected_attributes = {
        'start_time' => enrollment_params[:start_time],
        'end_time' => enrollment_params[:end_time],
        'member_id' => enrollment_params[:member_id]
      }
      expect(enrollment.reload.attributes).to include(expected_attributes)
    end

    it 'confirms the enrollment updates' do
      update_enrollment
      follow_redirect!

      expect(flash[:notice]).to include(I18n.t('enrollments.update.confirm_update'))
    end

    context 'with an invalid enrollment' do
      let(:enrollment_params) do
        attributes_for(:enrollment,
                       start_time: mission.start_date,
                       end_time: mission.start_date - 10.minutes,
                       member_id: member.id)
      end

      it 'displays an error flash' do
        update_enrollment
        expect(controller.flash[:error]).to be_present
      end
    end
  end
end
