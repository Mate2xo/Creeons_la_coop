# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MissionsController, type: :controller do
  let(:member) { create :member }
  let(:super_admin) { create :member, :super_admin }
  let(:mission) { create :mission }
  let(:valid_attributes) { attributes_for(:mission) }
  let(:invalid_attributes) do { name: '' } end

  before { sign_in super_admin }

  describe "GET index" do
    before { get :index }

    it "assigns @mission" do expect(assigns(:missions)).to include(mission) end
    it { expect(response).to have_http_status(:success) }
  end

  describe "GET show" do
    before { get :show, params: { id: mission.id } }

    it { expect(response).to have_http_status :success }
    it "assigns @mission" do expect(assigns(:mission)).to eq(mission) end
  end

  describe "GET edit" do
    before { get :edit, params: { id: mission.id } }

    it { expect(response).to have_http_status :success }
    it "assigns @mission" do expect(assigns(:mission)).to eq(mission) end
  end

  describe "PUT update" do
    context 'with valid params' do
      before {
        put :update, params: { id: mission.id, mission: valid_attributes }
        mission.reload
      }

      it "assigns @mission" do
        expect(assigns(:mission)).to eq(mission)
      end

      it { expect(response).to render_template(:show) }

      it "updates the .name attribute" do
        expect(mission.name).to eq(valid_attributes[:name])
      end

      it "updates the .description attribute" do
        expect(mission.description).to eq(valid_attributes[:description])
      end

      it "updates the .max_member_count attribute" do
        expect(mission.max_member_count).to eq(valid_attributes[:max_member_count])
      end

      it "updates the .min_member_count attribute" do
        expect(mission.min_member_count).to eq(valid_attributes[:min_member_count])
      end

      it "updates the .start_date attribute" do
        expect(mission.start_date).to eq(valid_attributes[:start_date])
      end

      it "updates the .due_date attribute" do
        expect(mission.due_date).to eq(valid_attributes[:due_date])
      end
    end

    context 'with invalid params' do
      it 'redirects to the edit form' do
        put :update, params: { id: mission.id, mission: invalid_attributes }
        expect(response).to render_template(:edit)
      end

      it 'does not change the mission' do
        expect{
          put :update, params: { id: mission.id, mission: invalid_attributes }
        }.not_to change(mission.reload.name, :methods)
      end
    end
  end

  describe "DELETE" do
    it "successfully deletes a mission record" do
      mission
      expect {
        delete :destroy, params: { id: mission.id }
      }.to change(Mission, :count).by(-1)
    end
  end

  describe "Recurrent missions creation" do
    let(:mission_params) {
      build(:mission, start_date: DateTime.now,
                      due_date: 3.hours.from_now,
                      recurrent: true).attributes
    }

    before {
      mission_params["recurrence_rule"] = "{\"interval\":1, \"until\":null, \"count\":null, \"validations\":{ \"day\":[2,3,5,6] }, \"rule_type\":\"IceCube::WeeklyRule\", \"week_start\":1 }"
      mission_params["recurrence_end_date"] = 1.week.from_now
    }

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

    context "when no recurrence_rule is given" do
      before {
        mission_params["recurrence_rule"] = ""
        post :create, params: { mission: mission_params }
      }

      it "does not create missions" do
        expect(Mission.count).to eq 0
      end

      it "redirects to :new form" do
        expect(response).to render_template(:new)
      end
    end

    context "when no recurrence_end_date is given" do
      before {
        mission_params["recurrence_end_date"] = ""
        post :create, params: { mission: mission_params }
      }

      it "does not create missions" do
        expect(Mission.count).to eq 0
      end

      it "redirects to :new form" do
        expect(response).to render_template(:new)
      end
    end

    context "when recurrence_end_date is prior to present day" do
      before {
        mission_params["recurrence_end_date"] = 1.month.ago
        post :create, params: { mission: mission_params }
      }

      it "does not create missions" do
        expect(Mission.count).to eq 0
      end

      it "redirects to :new form" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "'unauthorized' redirections" do
    before { sign_in member }

    context "with :edit" do
      it { expect(get(:edit, params: { id: mission.id })).to redirect_to(root_path) }
    end

    context "with :update" do
      it {
        expect(post(:update, params: {
                      id: mission.id,
                      mission: valid_attributes
                    })).to redirect_to(root_path)
      }
    end

    context "with :destroy" do
      it { expect(post(:destroy, params: { id: mission.id })).to redirect_to(root_path) }
    end
  end
end
