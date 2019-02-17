# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::MissionsController, type: :controller do
  let(:super_admin) { create(:member, :super_admin) }
  before { sign_in super_admin }

  let!(:mission) { create(:mission) }

  let(:valid_attributes) { attributes_for(:mission) }

  let(:invalid_attributes) do
    { name: '' }
  end

  describe "GET index" do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
    it 'assigns the mission' do
      get :index
      expect(assigns(:missions)).to include(mission)
    end
    # it "should render the expected columns" do
    #   get :index
    #   expect(page).to have_content(person.first_name)
    #   expect(page).to have_content(person.last_name)
    #   expect(page).to have_content(person.email)
    # end
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
    #   it "should render the form elements" do
    #     get :new
    #     expect(page).to have_field('First name')
    #     expect(page).to have_field('Last name')
    #     expect(page).to have_field('Email')
    #   end
  end

  # describe "POST create" do
  #   context "with valid params" do
  #     it "creates a new Mission" do
  #       expect {
  #         post :create, params: { mission: valid_attributes }
  #       }.to change(Mission, :count).by(1)
  #     end

  #     it "assigns a newly created person as @person" do
  #       post :create, params: { person: valid_attributes }
  #       expect(assigns(:person)).to be_a(Person)
  #       expect(assigns(:person)).to be_persisted
  #     end

  #     it "redirects to the created person" do
  #       post :create, params: { person: valid_attributes }
  #       expect(response).to have_http_status(:redirect)
  #       expect(response).to redirect_to(admin_person_path(Person.last))
  #     end

  #     it 'should create the person' do
  #       post :create, params: { person: valid_attributes }
  #       person = Person.last

  #       expect(person.first_name).to eq(valid_attributes[:first_name])
  #       expect(person.last_name).to  eq(valid_attributes[:last_name])
  #       expect(person.email).to      eq(valid_attributes[:email])
  #     end
  # end

  #   context "with invalid params" do
  #     it 'invalid_attributes return http success' do
  #       post :create, params: { person: invalid_attributes }
  #       expect(response).to have_http_status(:success)
  #     end

  #     it "assigns a newly created but unsaved person as @person" do
  #       post :create, params: { person: invalid_attributes }
  #       expect(assigns(:person)).to be_a_new(Person)
  #     end

  #     it 'invalid_attributes do not create a Person' do
  #       expect do
  #         post :create, params: { person: invalid_attributes }
  #       end.not_to change(Person, :count)
  #     end
  #   end
  # end

  # describe "GET edit" do
  #   before do
  #     get :edit, params: { id: person.id }
  #   end
  #   it 'returns http success' do
  #     expect(response).to have_http_status(:success)
  #   end
  #   it 'assigns the person' do
  #     expect(assigns(:person)).to eq(person)
  #   end
  #   it "should render the form elements" do
  #     expect(page).to have_field('First name', with: person.first_name)
  #     expect(page).to have_field('Last name', with: person.last_name)
  #     expect(page).to have_field('Email', with: person.email)
  #   end
  # end

  # describe "PUT update" do
  #   context 'with valid params' do
  #     before do
  #       put :update, params: { id: person.id, person: valid_attributes }
  #     end
  #     it 'assigns the person' do
  #       expect(assigns(:person)).to eq(person)
  #     end
  #     it 'returns http redirect' do
  #       expect(response).to have_http_status(:redirect)
  #       expect(response).to redirect_to(admin_person_path(person))
  #     end
  #     it "should update the person" do
  #       person.reload

  #       expect(person.last_name).to  eq(valid_attributes[:last_name])
  #       expect(person.first_name).to eq(valid_attributes[:first_name])
  #       expect(person.email).to      eq(valid_attributes[:email])
  #     end
  #   end
  #   context 'with invalid params' do
  #     it 'returns http success' do
  #       put :update, params: { id: person.id, person: invalid_attributes }
  #       expect(response).to have_http_status(:success)
  #     end
  #     it 'does not change person' do
  #       expect do
  #         put :update, params: { id: person.id, person: invalid_attributes }
  #       end.not_to change { person.reload.first_name }
  #     end
  #   end
  # end

  # describe "GET show" do
  #   before do
  #     get :show, params: { id: person.id }
  #   end
  #   it 'returns http success' do
  #     expect(response).to have_http_status(:success)
  #   end
  #   it 'assigns the person' do
  #     expect(assigns(:person)).to eq(person)
  #   end
  #   it "should render the form elements" do
  #     expect(page).to have_content(person.last_name)
  #     expect(page).to have_content(person.first_name)
  #     expect(page).to have_content(person.email)
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested select_option" do
  #     expect {
  #       delete :destroy, params: { id: person.id }
  #     }.to change(Person, :count).by(-1)
  #   end

  #   it "redirects to the field" do
  #     delete :destroy, params: { id: person.id }
  #     expect(response).to redirect_to(admin_persons_path)
  #   end
  # end
end
