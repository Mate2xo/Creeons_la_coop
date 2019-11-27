# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MissionsController, type: :controller do
  let(:member) { create :member }
  let(:super_admin) { create :member, :super_admin }
  let(:mission) { create :mission }
  let(:valid_attributes) { attributes_for(:mission) }
  let(:invalid_attributes) do { name: '' } end

  context "as a member," do
    before { sign_in member }

    describe "GET index" do
      before { get :index }

      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:missions)).to include(mission) }
    end

    describe "GET show" do
      before { get :show, params: { id: mission.id } }

      it { expect(response).to have_http_status :success }
      it { expect(assigns(:mission)).to eq(mission) }
    end

    describe "updating a mission that he created" do
      let(:authored_mission) { create :mission, author: member }

      context "when accessing #edit" do
        before { get :edit, params: { id: authored_mission.id } }

        it { expect(response).to have_http_status :success }
        it { expect(assigns(:mission)).to eq(authored_mission) }
      end

      context "when accessing #update" do
        context 'with valid params' do
          before { put :update, params: { id: authored_mission.id, mission: valid_attributes } }

          it { expect(assigns(:mission)).to eq(authored_mission) }
          it { expect(response).to render_template(:show) }

          it "update the attributes" do
            authored_mission.reload
            expect(authored_mission.name).to eq(valid_attributes[:name])
            expect(authored_mission.description).to eq(valid_attributes[:description])
          end
        end

        context 'with invalid params' do
          it 'redirects to the edit form' do
            put :update, params: { id: authored_mission.id, mission: invalid_attributes }
            expect(response).to render_template(:edit)
          end

          it 'does not change the mission' do
            expect{
              put :update, params: { id: authored_mission.id, mission: invalid_attributes }
            }.not_to change(authored_mission.reload.name, :methods)
          end
        end
      end
    end

    describe "no-authorization redirections" do
      it { expect(get(:edit, params: { id: mission.id })).to redirect_to(root_path) }
      it {
        expect(post(:update, params: {
                      id: mission.id,
                      mission: valid_attributes
                    })).to redirect_to(root_path)
      }
      it { expect(post(:destroy, params: { id: mission.id })).to redirect_to(root_path) }
    end
  end

  context "as a super_admin" do
    before {
      sign_in super_admin
    }

    it "can edit any mission" do
      get :edit, params: { id: mission.id }
      expect(response).to have_http_status(:success)
    end

    it "can update any mission" do
      put :update, params: { id: mission.id, mission: valid_attributes }
      expect(mission.reload.name).to eq(valid_attributes[:name])
    end

    it "can destroy any mission" do
      mission
      expect {
        delete :destroy, params: { id: mission.id }
      }.to change(Mission, :count).by(-1)
    end

    context "when creating recurrent missions:" do
      let(:mission_params) {
        build(:mission, start_date: DateTime.now,
                        due_date: 3.hours.from_now,
                        recurrent: true).attributes
      }
      before {
        mission_params["recurrence_rule"] = "{\"interval\":1, \"until\":null, \"count\":null, \"validations\":{ \"day\":[2,3,5,6] }, \"rule_type\":\"IceCube::WeeklyRule\", \"week_start\":1 }"
        mission_params["recurrence_end_date"] = 1.week.from_now
      }

      it "validates that the recurrence_rule and recurrence_end_date are present" do
        mission_params["recurrence_rule"] = ""
        mission_params["recurrence_end_date"] = ""

        post :create, params: { mission: mission_params }

        expect(Mission.count).to eq 0
        expect(response).to render_template(:new)
      end

      it "validates that recurrence_end_date is at least set to the present day" do
        mission_params["recurrence_end_date"] = 1.month.ago

        post :create, params: { mission: mission_params }

        expect(Mission.count).to eq 0
        expect(response).to render_template(:new)
      end

      it "sets the maximum recurrence_end_date to the end of next month" do
        mission_params["recurrence_end_date"] = 6.months.from_now.to_s

        post :create, params: { mission: mission_params }

        expect(Mission.last.due_date).to be < 2.months.from_now.beginning_of_month
      end

      it "creates a mission instance for each occurence" do
        post :create, params: { mission: mission_params }
        expect(Mission.count).to be_within(1).of(4) # depends on the day on which the test is run
      end

      it "redirects to /missions when finished creating all occurrences" do
        post :create, params: { mission: mission_params }
        expect(response).to redirect_to missions_path
      end
    end
  end
end
