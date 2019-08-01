# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::MissionsController, type: :controller do
  render_views
  let(:page) { Capybara::Node::Simple.new(response.body) }
  let(:super_admin) { create(:member, :super_admin) }
  let(:valid_attributes) { build(:mission).attributes }
  let(:invalid_attributes) do
    { name: '' }
  end
  let!(:mission) { create(:mission) }
  before { sign_in super_admin }

  describe "GET index" do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
    it 'assigns the mission' do
      get :index
      expect(assigns(:missions)).to include(mission)
    end
    it "should render the expected columns" do
      get :index
      expect(page).to have_content(mission.author.email)
      expect(page).to have_content(mission.name)
      expect(page).to have_content(mission.description)
      expect(page).to have_content(I18n.localize(mission.due_date, format: :long))
    end
    # let(:filters_sidebar) { page.find('#filters_sidebar_section') }
    # it "filter Name exists" do
    #   get :index
    #   expect(filters_sidebar).to have_css('label[for="q_first_name_or_last_name_cont"]', text: 'Name')
    #   expect(filters_sidebar).to have_css('input[name="q[first_name_or_last_name_cont]"]')
    # end
    # it "filter Name works" do
    #   matching_person = Fabricate :person, first_name: 'ABCDEFG'
    #   non_matching_person = Fabricate :person, first_name: 'HIJKLMN'

    #   get :index, params: { q: { first_name_or_last_name_cont: 'BCDEF' } }

    #   expect(assigns(:persons)).to include(matching_person)
    #   expect(assigns(:persons)).not_to include(non_matching_person)
    # end
  end

  describe "GET new" do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
    it 'assigns the person' do
      get :new
      expect(assigns(:mission)).to be_a_new(Mission)
    end
    it "should render the form elements" do
      get :new
      expect(page).to have_field('Author')
      expect(page).to have_field('Name')
      expect(page).to have_field('Description')
      expect(page).to have_field('Due date')
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "creates a new Mission" do
        expect {
          post :create, params: { mission: valid_attributes }
        }.to change(Mission, :count).by(1)
      end

      it "assigns a newly created mission as @mission" do
        post :create, params: { mission: valid_attributes }
        expect(assigns(:mission)).to be_a(Mission)
        expect(assigns(:mission)).to be_persisted
      end

      it "redirects to the created mission" do
        post :create, params: { mission: valid_attributes }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_mission_path(Mission.last))
      end

      it 'should create the mission' do
        post :create, params: { mission: valid_attributes }
        mission = Mission.last

        expect(mission.name).to eq(valid_attributes["name"])
        expect(mission.description).to eq(valid_attributes["description"])
        expect(mission.due_date).to eq(valid_attributes["due_date"])
      end
    end

    context "with invalid params" do
      it 'invalid_attributes return http success' do
        post :create, params: { mission: invalid_attributes }
        expect(response).to have_http_status(:success)
      end

      it "assigns a newly created but unsaved mission as @mission" do
        post :create, params: { mission: invalid_attributes }
        expect(assigns(:mission)).to be_a_new(Mission)
      end

      it 'invalid_attributes do not create a Mission' do
        expect do
          post :create, params: { mission: invalid_attributes }
        end.not_to change(Mission, :count)
      end

      it "does not create a mission when due_date < start_date" do
        skip
      end
    end
  end

  describe "GET edit" do
    before do
      get :edit, params: { id: mission.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the mission' do
      expect(assigns(:mission)).to eq(mission)
    end
    it "should render the form elements" do
      expect(page).to have_select('Author', with_options: [mission.author.email])
      expect(page).to have_field('Name', with: mission.name)
      expect(page).to have_field('Description', with: mission.description)
      expect(page).to have_select('Due date')
    end
  end

  describe "PUT update" do
    context 'with valid params' do
      before do
        put :update, params: { id: mission.id, mission: valid_attributes }
      end
      it 'assigns the mission' do
        expect(assigns(:mission)).to eq(mission)
      end
      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_mission_path(mission))
      end
      it "should update the mission" do
        mission.reload

        expect(mission.name).to eq(valid_attributes["name"])
        expect(mission.description).to eq(valid_attributes["description"])
        expect(mission.due_date).to eq(valid_attributes["due_date"])
      end
    end
    context 'with invalid params' do
      it 'returns http success' do
        put :update, params: { id: mission.id, mission: invalid_attributes }
        expect(response).to have_http_status(:success)
      end
      it 'does not change mission' do
        expect do
          put :update, params: { id: mission.id, mission: invalid_attributes }
        end.not_to change(mission.reload.name, :methods)
      end
    end
  end

  describe "GET show" do
    before do
      get :show, params: { id: mission.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the mission' do
      expect(assigns(:mission)).to eq(mission)
    end
    it "should render the form elements" do
      expect(page).to have_content(mission.name)
      expect(page).to have_content(mission.description)
      expect(page).to have_content(I18n.localize(mission.due_date, format: :long))
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested select_option" do
      expect {
        delete :destroy, params: { id: mission.id }
      }.to change(Mission, :count).by(-1)
    end

    it "redirects to the field" do
      delete :destroy, params: { id: mission.id }
      expect(response).to redirect_to(admin_missions_path)
    end
  end
end
