# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MissionsController, type: :controller do
  let(:member) { create :member }
  let(:super_admin) { create :member, :super_admin }
  let(:mission) { create :mission }
  let(:valid_attributes) { attributes_for(:mission) }

  before { sign_in super_admin }

  describe 'GET index' do
    before { get :index }

    it 'assigns @mission' do expect(assigns(:missions)).to include(mission) end
    it { expect(response).to have_http_status(:success) }
  end

  describe 'GET show' do
    before { get :show, params: { id: mission.id } }

    it { expect(response).to have_http_status :success }
    it 'assigns @mission' do expect(assigns(:mission)).to eq(mission) end
  end

  describe 'GET edit' do
    before { get :edit, params: { id: mission.id } }

    it { expect(response).to have_http_status :success }
    it 'assigns @mission' do expect(assigns(:mission)).to eq(mission) end
  end

  describe 'PUT update' do
    context 'with valid params' do
      before do
        put :update, params: { id: mission.id, mission: valid_attributes }
        mission.reload
      end

      it 'assigns @mission' do expect(assigns(:mission)).to eq(mission) end
      it { expect(response).to render_template(:show) }

      %i[
        name description max_member_count min_member_count start_date due_date
      ].each do |attribute|
        it "updates the :#{attribute} attribute" do
          expect(mission.send(attribute)).to eq(valid_attributes[attribute])
        end
      end
    end

    context 'with invalid params' do
      def invalid_request(invalid_attribute)
        put :update, params: { id: mission.id, mission: { "#{invalid_attribute}": '' } }
      end

      %w[name description min_member_count start_date].each do |attribute|
        it 'redirects to the edit form' do
          invalid_request(attribute)
          expect(response).to redirect_to edit_mission_path
        end

        it "does not change the mission :#{attribute} attribute" do
          expect { invalid_request(attribute) }.not_to(change { mission.reload.send(attribute) })
        end
      end
    end
  end

  describe 'DELETE' do
    it 'successfully deletes a mission record' do
      mission
      expect do
        delete :destroy, params: { id: mission.id }
      end.to change(Mission, :count).by(-1)
    end
  end

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
