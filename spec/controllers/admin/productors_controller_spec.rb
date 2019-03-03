# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProductorsController, type: :controller do
  # this lets us inspect the rendered results
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }
  let(:super_admin) { create(:member, :super_admin) }
  before { sign_in super_admin }

  let!(:productor) { create(:productor) }

  let(:valid_attributes) { attributes_for(:productor) }

  let(:invalid_attributes) do
    { name: '' }
  end

  describe "GET index" do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
    it 'assigns the productor' do
      get :index
      expect(assigns(:productors)).to include(productor)
    end
    it "should render the expected columns" do
      get :index
      expect(page).to have_content(productor.name)
      expect(page).to have_content(productor.website_url)
      expect(page).to have_content(productor.phone_number)
    end
    #   let(:filters_sidebar) { page.find('#filters_sidebar_section') }
    #   it "filter Name exists" do
    #     get :index
    #     expect(filters_sidebar).to have_css('label[for="q_first_name_or_last_name_cont"]', text: 'Name')
    #     expect(filters_sidebar).to have_css('input[name="q[first_name_or_last_name_cont]"]')
    #   end
    #   it "filter Name works" do
    #     matching_person = Fabricate :person, first_name: 'ABCDEFG'
    #     non_matching_person = Fabricate :person, first_name: 'HIJKLMN'

    #     get :index, params: { q: { first_name_or_last_name_cont: 'BCDEF' } }

    #     expect(assigns(:persons)).to include(matching_person)
    #     expect(assigns(:persons)).not_to include(non_matching_person)
    #   end
  end

  describe "GET new" do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
    it 'assigns the productor' do
      get :new
      expect(assigns(:productor)).to be_a_new(Productor)
    end
    it "should render the form elements" do
      get :new
      expect(page).to have_field('Name')
      expect(page).to have_field('Description')
      expect(page).to have_field('Phone number')
      expect(page).to have_field('Website url')
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "creates a new Productor" do
        expect {
          post :create, params: { productor: valid_attributes }
        }.to change(Productor, :count).by(1)
      end

      it "assigns a newly created Productor as @productor" do
        post :create, params: { productor: valid_attributes }
        expect(assigns(:productor)).to be_a(Productor)
        expect(assigns(:productor)).to be_persisted
      end

      it "redirects to the created productor" do
        post :create, params: { productor: valid_attributes }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_productor_path(Productor.last))
      end

      it 'should create the productor' do
        post :create, params: { productor: valid_attributes }
        productor = Productor.last

        expect(productor.name).to eq(valid_attributes[:name])
        expect(productor.description).to eq(valid_attributes[:description])
        expect(productor.phone_number).to eq(valid_attributes[:phone_number])
      end
    end

    context "with invalid params" do
      it 'invalid_attributes return http success' do
        post :create, params: { productor: invalid_attributes }
        expect(response).to have_http_status(:success)
      end

      it "assigns a newly created but unsaved productor as @productor" do
        post :create, params: { productor: invalid_attributes }
        expect(assigns(:productor)).to be_a_new(Productor)
      end

      it 'invalid_attributes do not create a Productor' do
        expect do
          post :create, params: { productor: invalid_attributes }
        end.not_to change(Productor, :count)
      end
    end
  end

  describe "GET edit" do
    before do
      get :edit, params: { id: productor.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the productor' do
      expect(assigns(:productor)).to eq(productor)
    end
    it "should render the form elements" do
      expect(page).to have_field('Name', with: productor.name)
      expect(page).to have_field('Description', with: productor.description)
      expect(page).to have_field('Phone number', with: productor.phone_number)
      expect(page).to have_field('Website url', with: productor.website_url)
    end
  end

  describe "PUT update" do
    context 'with valid params' do
      before do
        put :update, params: { id: productor.id, productor: valid_attributes }
      end
      it 'assigns the productor' do
        expect(assigns(:productor)).to eq(productor)
      end
      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_productor_path(productor))
      end
      it "should update the productor" do
        productor.reload

        expect(productor.name).to eq(valid_attributes[:name])
        expect(productor.description).to eq(valid_attributes[:description])
        expect(productor.phone_number).to eq(valid_attributes[:phone_number])
        expect(productor.website_url).to eq(valid_attributes[:website_url])
      end
    end
    context 'with invalid params' do
      it 'returns http success' do
        put :update, params: { id: productor.id, productor: invalid_attributes }
        expect(response).to have_http_status(:success)
      end
      it 'does not change productor' do
        expect do
          put :update, params: { id: productor.id, productor: invalid_attributes }
        end.not_to change(productor.reload.name, :methods)
      end
    end
  end

  describe "GET show" do
    before do
      get :show, params: { id: productor.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the productor' do
      expect(assigns(:productor)).to eq(productor)
    end
    it "should render the form elements" do
      expect(page).to have_content(productor.name)
      expect(page).to have_content(productor.description)
      expect(page).to have_content(productor.phone_number)
      expect(page).to have_content(productor.website_url)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested select_option" do
      expect {
        delete :destroy, params: { id: productor.id }
      }.to change(Productor, :count).by(-1)
    end

    it "redirects to the field" do
      delete :destroy, params: { id: productor.id }
      expect(response).to redirect_to(admin_productors_path)
    end
  end
end
