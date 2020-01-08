# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::MissionsController, type: :controller do
  render_views
  let(:page) { Capybara::Node::Simple.new(response.body) }
  let(:super_admin) { create(:member, :super_admin) }
  let(:valid_attributes) { build(:mission).attributes }
  let(:invalid_attributes) { { name: '' } }
  let(:mission) { create(:mission) }

  before { sign_in super_admin }

  describe "GET index" do
    before {
      mission
      get :index
    }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the mission' do
      expect(assigns(:missions)).to include(mission)
    end
    it "renders the author column" do
      expect(page).to have_content(mission.author.display_name)
    end
    it "renders the name column" do
      expect(page).to have_content(mission.name)
    end
    it "renders the description column" do
      expect(page).to have_content(mission.description)
    end
    it "renders the due_date column" do
      expect(page).to have_content(I18n.localize(mission.due_date, format: :long))
    end
  end

  describe "GET new" do
    before { get :new }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the mission' do
      expect(assigns(:mission)).to be_a_new(Mission)
    end
    it "renders the author form elements" do
      expect(page).to have_field(I18n.t("activerecord.attributes.mission.author"))
    end
    it "renders the name form elements" do
      expect(page).to have_field(I18n.t("activerecord.attributes.mission.name"))
    end
    it "renders the description form elements" do
      expect(page).to have_field(I18n.t("activerecord.attributes.mission.description"))
    end
    it "renders the due_date form elements" do
      expect(page).to have_field(I18n.t("activerecord.attributes.mission.due_date"))
    end
  end

  describe "POST create" do
    context "when request is sent" do
      it "creates a new Mission with valid params" do
        expect {
          post :create, params: { mission: valid_attributes }
        }.to change(Mission, :count).by(1)
      end

      it 'does not create a Mission with invalid params' do
        expect do
          post :create, params: { mission: invalid_attributes }
        end.not_to change(Mission, :count)
      end

      it "does not create a mission when due_date < start_date" do
        invalid_attributes = attributes_for :mission,
                                            start_date: 1.day.from_now,
                                            due_date: 0.day.from_now
        expect { post :create, params: { mission: invalid_attributes } }
          .not_to change(Mission, :count)
      end
    end

    context "when valid params are given" do
      before { post :create, params: { mission: valid_attributes } }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(assigns(:mission)).to be_persisted }
      it "assigns a newly created mission as @mission" do
        expect(assigns(:mission)).to be_a(Mission)
      end
      it "redirects to the created mission" do
        expect(response).to redirect_to(admin_mission_path(Mission.last))
      end
      it 'sets the :name attribute' do
        expect(Mission.last.name).to eq(valid_attributes["name"])
      end
      it 'sets the :description attribute' do
        expect(Mission.last.description).to eq(valid_attributes["description"])
      end
      it 'sets the :start_date attribute' do
        expect(Mission.last.start_date).to eq(valid_attributes["start_date"])
      end
      it 'sets the :due_date attribute' do
        expect(Mission.last.due_date).to eq(valid_attributes["due_date"])
      end
    end

    context "with invalid params" do
      before { post :create, params: { mission: invalid_attributes } }

      it 'invalid_attributes return http success' do
        expect(response).to have_http_status(:success)
      end
      it "assigns a newly created but unsaved mission as @mission" do
        expect(assigns(:mission)).to be_a_new(Mission)
      end
    end
  end

  describe "GET edit" do
    before { get :edit, params: { id: mission.id } }

    it { expect(response).to have_http_status(:success) }
    it 'assigns the mission' do
      expect(assigns(:mission)).to eq(mission)
    end
    it "renders the author form element" do
      expect(page).to have_select(I18n.t("activerecord.attributes.mission.author"),
                                  with_options: [mission.author.email])
    end
    it "renders the name form element" do
      expect(page).to have_field(I18n.t("activerecord.attributes.mission.name"),
                                 with: mission.name)
    end
    it "renders the description form element" do
      expect(page).to have_field(I18n.t("activerecord.attributes.mission.description"),
                                 with: mission.description)
    end
    it "renders the start_date form element" do
      expect(page).to have_select(I18n.t("activerecord.attributes.mission.start_date"))
    end
    it "renders the due_date form element" do
      expect(page).to have_select(I18n.t("activerecord.attributes.mission.due_date"))
    end
    it "renders the min_member_count form element" do
      expect(page).to have_field(I18n.t("activerecord.attributes.mission.min_member_count"))
    end
    it "renders the max_member_count form element" do
      expect(page).to have_field(I18n.t("activerecord.attributes.mission.max_member_count"))
    end
  end

  describe "PUT update" do
    context 'with valid params' do
      before {
        put :update, params: { id: mission.id, mission: valid_attributes }
        mission.reload
      }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(admin_mission_path(mission)) }
      it 'assigns the mission' do
        expect(assigns(:mission)).to eq(mission)
      end
      it "updates the :name attribute" do
        expect(mission.name).to eq(valid_attributes["name"])
      end
      it "updates the :description attribute" do
        expect(mission.description).to eq(valid_attributes["description"])
      end
      it "updates the :start_date attribute" do
        expect(mission.start_date).to eq(valid_attributes["start_date"])
      end
      it "updates the :due_date attribute" do
        expect(mission.due_date).to eq(valid_attributes["due_date"])
      end
    end

    context 'with invalid params' do
      it 'returns http success' do
        put :update, params: { id: mission.id, mission: invalid_attributes }
        expect(response).to have_http_status(:success)
      end
      it 'does not change mission' do
        expect {
          put :update, params: { id: mission.id, mission: invalid_attributes }
        }.not_to change(mission.reload.name, :methods)
      end
    end
  end

  describe "GET show" do
    before { get :show, params: { id: mission.id } }

    it { expect(response).to have_http_status(:success) }
    it 'assigns the mission' do
      expect(assigns(:mission)).to eq(mission)
    end
    it "renders the name form element" do
      expect(page).to have_content(mission.name)
    end
    it "renders the description form element" do
      expect(page).to have_content(mission.description)
    end
    it "renders the due_date form element" do
      expect(page).to have_content(I18n.localize(mission.due_date, format: :long))
    end
  end

  describe "DELETE #destroy" do
    before { mission }

    it "destroys the requested mission" do
      expect {
        delete :destroy, params: { id: mission.id }
      }.to change(Mission, :count).by(-1)
    end

    it "redirects to the missions index" do
      delete :destroy, params: { id: mission.id }
      expect(response).to redirect_to(admin_missions_path)
    end
  end
end
