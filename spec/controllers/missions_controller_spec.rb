# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MissionsController, type: :controller do
  let(:member) { create :member }
  let(:super_admin) { create :member, :super_admin }
  let(:mission) { create :mission }
  let(:valid_attributes) { attributes_for(:mission) }

  before { sign_in super_admin }

  describe 'Recurrent missions creation' do
    let(:mission_params) do
      build(:mission, start_date: DateTime.now,
                      due_date: 3.hours.from_now,
                      recurrent: true).attributes
    end

    before do
      mission_params['recurrence_rule'] = '{"interval":1, "until":null, "count":null, "validations":{ "day":[2,3,5,6] }, "rule_type":"IceCube::WeeklyRule", "week_start":1 }'
      mission_params['recurrence_end_date'] = 1.week.from_now
    end

    it 'sets the maximum recurrence_end_date to the end of next month' do
      mission_params['recurrence_end_date'] = 6.months.from_now.to_s

      post :create, params: { mission: mission_params }

      expect(Mission.last.due_date).to be < 2.months.from_now.beginning_of_month
    end

    it 'creates a mission instance for each occurence' do
      post :create, params: { mission: mission_params }
      expect(Mission.count).to be_within(1).of(4) # depends on the day on which the test is run
    end

    it 'redirects to /missions when finished creating all occurrences' do
      post :create, params: { mission: mission_params }
      expect(response).to redirect_to missions_path
    end

    context 'when no recurrence_rule is given' do
      before do
        mission_params['recurrence_rule'] = ''
        post :create, params: { mission: mission_params }
      end

      it 'does not create missions' do
        expect(Mission.count).to eq 0
      end

      it 'redirects to :new form' do
        expect(response).to render_template(:new)
      end
    end

    context 'when no recurrence_end_date is given' do
      before do
        mission_params['recurrence_end_date'] = ''
        post :create, params: { mission: mission_params }
      end

      it 'does not create missions' do
        expect(Mission.count).to eq 0
      end

      it 'redirects to :new form' do
        expect(response).to render_template(:new)
      end
    end

    context 'when recurrence_end_date is prior to present day' do
      before do
        mission_params['recurrence_end_date'] = 1.month.ago
        post :create, params: { mission: mission_params }
      end

      it 'does not create missions' do
        expect(Mission.count).to eq 0
      end

      it 'redirects to :new form' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "'unauthorized' redirections" do
    before { sign_in member }

    # context "with :edit" do
    #   it { expect(get(:edit, params: { id: mission.id })).to redirect_to(root_path) }
    # end

    # context "with :update" do
    #   it {
    #     expect(post(:update, params: {
    #                   id: mission.id,
    #                   mission: valid_attributes
    #                 })).to redirect_to(root_path)
    #   }
    # end

    context 'with :destroy' do
      it { expect(post(:destroy, params: { id: mission.id })).to redirect_to(root_path) }
    end
  end
end
