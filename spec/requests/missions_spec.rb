# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/missions' do
  before { sign_in create :member }

  describe 'GET /' do
    subject(:index) { create_list(:mission, 2) and get missions_path }

    it 'has an HTTP :OK status' do
      index
      expect(response).to have_http_status(:ok)
    end

    context 'with a JSON request' do
      subject(:index) { setup_missions and get missions_path, as: :json }

      let(:setup_missions) { create_list(:mission, 2) }

      it 'has an HTTP :OK status' do
        index
        expect(response).to have_http_status(:ok)
      end

      it 'returns mission records' do
        index
        expect(response.parsed_body.size).to eq 2
      end

      context 'with date-filtering params' do
        subject(:index) { setup_missions and get missions_path, as: :json, params: }

        let(:params) do
          {start: '2024-03-11T00:00:00Z', end: '2024-03-18T00:00:00Z', timeZone: 'UTC'}
        end
        let(:setup_missions) do
          create(:mission, start_date: Date.new(2024, 3, 11))
          create(:mission, start_date: Date.new(2024, 4, 11))
        end

        it 'returns only missions in the required time period', :aggregate_failures do
          index

          expect(response.parsed_body.size).to eq 1
          expect(Date.parse(response.parsed_body.first['start'])).to eq Date.new(2024, 3, 11)
        end

        context 'with unexpected date-filtering params' do
          subject(:index) { setup_missions and get missions_path, as: :json, params: }

          let(:params) do
            {start: '; raise BOOM', end: 'aa 123047 %; ""', timeZone: 'UTC'}
          end

          it 'ignores them and returns all records' do
            index
            expect(response.parsed_body.size).to eq 2
          end
        end
      end
    end
  end

  describe 'GET /:id' do
    subject(:show) { get mission_path(mission) }

    let(:mission) { create(:mission) }

    it 'has a successful HTTP response' do
      show
      expect(response).to have_http_status :success
    end

    it 'renders the standard partial' do
      show
      expect(response).to render_template('missions/_standard_quick_enrollment_form')
    end

    context 'when the genre is set to regulated' do
      let(:mission) { create(:mission, genre: :regulated) }

      it 'renders the regulated partial' do
        show
        expect(response).to render_template('missions/_regulated_quick_enrollment_form')
      end
    end
  end

  describe 'POST /' do
    subject(:create_mission) { post missions_path, params: {mission: mission_params} }

    before { sign_in create :member, :super_admin }

    let(:mission_params) { attributes_for(:mission).except(:enrollments) }

    it 'creates the mission' do
      create_mission

      mission_params.each do |key, value|
        expect(Mission.last.attributes[key.to_s]).to eq value
      end
    end

    context 'when the genre is set to event' do
      let(:mission_params) { attributes_for(:mission, genre: 'event').except(:enrollments) }

      it 'creates the mission with the specified params' do
        create_mission

        mission_params.each do |key, value|
          expect(Mission.last.attributes[key.to_s]).to eq value
        end
      end
    end

    context 'when due date is inferior to start_date' do
      let(:mission_params) do
        current_time = DateTime.current
        attributes_for(:mission, start_date: current_time, due_date: current_time - 5.minutes)
      end

      it 'rollbacks and sets duration minimum error feedback' do
        create_mission
        follow_redirect!

        expect(Mission.count).to be(0)
        expect(response.body).to include(I18n.t('activerecord.errors.models.mission.attributes.duration.minimum'))
      end
    end

    context 'when duration is superior to ten hours' do
      let(:mission_params) do
        current_time = DateTime.current
        attributes_for(:mission, start_date: current_time, due_date: current_time + 11.hours)
      end

      it 'rollbacks and sets a maximum duration error feedback' do
        create_mission
        follow_redirect!

        expect(Mission.count).to be(0)
        expect(response.body).to include(I18n.t('activerecord.errors.models.mission.attributes.duration.maximum'))
      end
    end

    context 'when mission is regulated and duration is not a multiple of 1.5 hours' do
      let(:mission_params) do
        current_time = DateTime.current
        attributes_for(:mission, genre: 'regulated', start_date: current_time, due_date: current_time + 2.hours)
      end

      it 'rollbacks and sets a duration multiple error feedback' do
        create_mission
        follow_redirect!

        expect(Mission.count).to be(0)
        expect(CGI.unescapeHTML(response.body))
          .to include(I18n.t('activerecord.errors.models.mission.attributes.duration.multiple'))
      end
    end

    context 'with a recurrent mission' do
      subject(:create_recurrent_mission) { post missions_path, params: {mission: mission_params} }

      let(:mission_params) do
        attributes_for(:mission,
                       start_date: DateTime.current.beginning_of_week,
                       due_date: DateTime.current.beginning_of_week + 3.hours,
                       recurrent: true,
                       recurrence_rule: '{"interval":1, "until":null, "count":null, "validations":{ "day":[2,3,5,6] }, "rule_type":"IceCube::WeeklyRule", "week_start":1 }',
                       recurrence_end_date: DateTime.now.beginning_of_week + 1.week)
      end

      it 'sets the maximum recurrence_end_date to the end of next month' do
        mission_params['recurrence_end_date'] = 6.months.from_now.to_s
        create_recurrent_mission
        expect(Mission.last.due_date).to be < 2.months.from_now.beginning_of_month
      end

      it 'creates a mission instance for each occurence' do
        create_recurrent_mission
        expect(Mission.count).to eq(4) # Tue, Wed, Fri, Sat
      end

      it 'redirects to /missions when finished creating all occurrences' do
        create_recurrent_mission
        expect(response).to redirect_to missions_path
      end

      context 'when no recurrence_rule are given' do
        let(:mission_params) do
          attributes_for(:mission,
                         start_date: DateTime.now,
                         due_date: 3.hours.from_now,
                         recurrent: true,
                         recurrence_rule: '',
                         recurrence_end_date: 1.week.from_now)
        end

        it 'does not create missions' do
          create_recurrent_mission
          expect(Mission.count).to eq 0
        end

        it 'redirects to :new form' do
          create_recurrent_mission
          expect(response).to render_template(:new)
        end
      end

      context 'when no recurrence_end_date is given' do
        let(:mission_params) do
          attributes_for(:mission,
                         start_date: DateTime.now,
                         due_date: 3.hours.from_now,
                         recurrent: true,
                         recurrence_rule: '{"interval":1, "until":null, "count":null, "validations":{ "day":[2,3,5,6] }, "rule_type":"IceCube::WeeklyRule", "week_start":1 }',
                         recurrence_end_date: '')
        end

        it 'does not create missions' do
          create_recurrent_mission
          expect(Mission.count).to eq 0
        end

        it 'redirects to :new form' do
          create_recurrent_mission
          expect(response).to render_template(:new)
        end
      end

      context 'when recurrence_end_date is prior to present day' do
        before do
          mission_params['recurrence_end_date'] = 1.month.ago
        end

        it 'does not create missions' do
          create_recurrent_mission
          expect(Mission.count).to eq 0
        end

        it 'redirects to :new form' do
          create_recurrent_mission
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'GET /:id/edit' do
    subject(:edit) { get edit_mission_path(mission.id) }

    let(:mission) { create(:mission) }

    before { sign_in create :member, :super_admin }

    it 'has a successful HTTP response' do
      edit
      expect(response).to have_http_status :success
    end

    it 'renders the standards partials' do
      edit
      expect(response).to render_template(partial: 'missions/_enrollments_form')
    end

    context 'when the mission is regulated' do
      let(:mission) { create(:mission, genre: 'regulated') }

      it 'rends the regulated partials' do
        edit

        expect(response).to render_template(partial: 'missions/_enrollment_with_time_slots_fields')
      end
    end
  end

  describe 'PUT /:id' do
    subject(:update) { put mission_path(mission.id), params: {mission: mission_params} }

    let(:mission) { create(:mission) }
    let(:mission_params) { {name: 'updated_mission'} }

    before { sign_in create :member, :super_admin }

    it { is_expected.to redirect_to mission_path(mission) }

    it 'updates the mission' do
      update
      expect(mission.reload.name).to eq 'updated_mission'
    end

    context 'with invalid params' do
      let(:mission_params) { {name: ''} }

      it { is_expected.to render_template :edit }
    end

    context 'with a regulated mission' do
      let(:mission) { create(:mission, genre: 'regulated') }

      it 'updates the mission' do
        update

        expect(mission.reload.name).to eq 'updated_mission'
      end
    end

    context 'with a regulated mission and when enrollment params are given' do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:member_other_than_the_currently_logged_in_user) { create(:member) }
      let(:enrollment_expected_params) do
        {member_id: member_other_than_the_currently_logged_in_user.id,
         start_time: mission.start_date,
         end_time: mission.start_date + 3.hours}
      end

      let(:enrollment_params) do
        {member_id: member_other_than_the_currently_logged_in_user.id,
         time_slots: [mission.start_date, mission.start_date + 90.minutes]}
      end
      let(:mission_params) do
        {name: 'updated_mission', genre: 'regulated', enrollments_attributes: {'1234': enrollment_params}}
      end

      it 'adds member enrollment' do
        put mission_path(mission.id), params: {mission: mission_params}

        expect(mission.reload.enrollments.first.attributes.symbolize_keys).to include enrollment_expected_params
      end
    end

    context 'with a regulated mission and when a part of time slots is given in enrollment params' do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:member_other_than_the_currently_logged_in_user) { create(:member) }
      let(:enrollment_expected_params) do
        {member_id: member_other_than_the_currently_logged_in_user.id,
         start_time: mission.start_date,
         end_time: mission.start_date + 90.minutes}
      end

      let(:enrollment_params) do
        {member_id: member_other_than_the_currently_logged_in_user.id, time_slots: [mission.start_date]}
      end

      let(:mission_params) do
        {name: 'updated_mission', genre: 'regulated', enrollments_attributes: {'1234': enrollment_params}}
      end

      it 'adds member enrollment' do
        update

        expect(mission.reload.enrollments.first.attributes.symbolize_keys).to include enrollment_expected_params
      end
    end

    context 'when the mission is :regulated and an other :genre is given' do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:mission_params) do
        {name: 'updated_mission', genre: 'standard'}
      end

      it 'updates the mission' do
        update

        expect(mission.reload.genre).to eq 'standard'
      end
    end

    context 'when the mission is :regulated, other :genre is given and enrollments params are given' do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:member_other_than_the_currently_logged_in_user) { create(:member) }
      let(:enrollment_expected_params) do
        {member_id: member_other_than_the_currently_logged_in_user.id,
         start_time: mission.start_date,
         end_time: mission.start_date + 3.hours}
      end

      let(:enrollment_params) do
        {member_id: member_other_than_the_currently_logged_in_user.id,
         time_slots: [mission.start_date, mission.start_date + 90.minutes]}
      end

      let(:mission_params) do
        {name: 'updated_mission', genre: 'standard', enrollments_attributes: {'1234': enrollment_params}}
      end

      it 'updates the mission' do
        update

        expect(mission.reload.genre).to eq 'standard'
      end

      it 'adds member enrollment' do
        update

        expect(mission.reload.enrollments.first.attributes.symbolize_keys).to include enrollment_expected_params
      end
    end

    context 'with :regulated mission and when the destroy params is given for an enrolled member' do
      let(:mission) { create(:mission, genre: 'regulated') }
      let(:member_other_than_the_currently_logged_in_user) { create(:member) }
      let(:enrollment) { create(:enrollment, member: member_other_than_the_currently_logged_in_user, mission: mission) }

      let(:enrollment_params) do
        {member_id: member_other_than_the_currently_logged_in_user.id, _destroy: '1', id: enrollment.id}
      end

      let(:mission_params) do
        {name: 'updated_mission', genre: 'regulated', enrollments_attributes: {'0': enrollment_params}}
      end

      it 'disenroll members from mission' do
        update

        expect(mission.members).not_to include(member_other_than_the_currently_logged_in_user)
      end
    end
  end

  describe 'DELETE /:id' do
    subject(:destroy) { delete mission_path(mission) }

    before { sign_in create :member, :super_admin }

    let!(:mission) { create(:mission) }

    it 'destroys the given record' do
      expect { destroy }.to change(Mission, :count).by(-1)
    end

    it 'sets a translated flash message' do
      destroy
      expect(controller.flash[:notice]).not_to include(/translation missing/i)
    end
  end
end
