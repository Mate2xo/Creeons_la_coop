# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::InfosController, type: :controller do
  # this lets us inspect the rendered results
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }
  let(:super_admin) { create(:member, :super_admin) }
  before { sign_in super_admin }

  let!(:info) { create(:info) }

  let(:valid_attributes) { build(:info).attributes }

  let(:invalid_attributes) do
    { title: '' }
  end

  describe "GET index" do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
    it 'assigns the info' do
      get :index
      expect(assigns(:infos)).to include(info)
    end
    it "should render the expected columns" do
      get :index
      expect(page).to have_content(info.content)
      expect(page).to have_content(info.title)
      expect(page).to have_content(info.author.display_name)
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
    it 'assigns the info' do
      get :new
      expect(assigns(:info)).to be_a_new(Info)
    end
    it "should render the form elements" do
      get :new
      expect(page).to have_field('info_title')
      expect(page).to have_field('info_content')
      expect(page).to have_field('info_author_id')
      expect(page).to have_field('info_category')
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "creates a new Info" do
        expect {
          post :create, params: { info: valid_attributes }
        }.to change(Info, :count).by(1)
      end

      it "assigns a newly created info as @info" do
        post :create, params: { info: valid_attributes }
        expect(assigns(:info)).to be_a(Info)
        expect(assigns(:info)).to be_persisted
      end

      it "redirects to the created info" do
        post :create, params: { info: valid_attributes }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_info_path(Info.last))
      end

      it 'should create the info' do
        post :create, params: { info: valid_attributes }
        info = Info.last

        expect(info.title).to eq(valid_attributes["title"])
        expect(info.content).to eq(valid_attributes["content"])
        expect(info.author_id).to eq(valid_attributes["author_id"])
      end
    end

    context "with invalid params" do
      it 'invalid_attributes return http success' do
        post :create, params: { info: invalid_attributes }
        expect(response).to have_http_status(:success)
      end

      it "assigns a newly created but unsaved info as @info" do
        post :create, params: { info: invalid_attributes }
        expect(assigns(:info)).to be_a_new(Info)
      end

      it 'invalid_attributes do not create a Info' do
        expect {
          post :create, params: { info: invalid_attributes }
        }.not_to change(Info, :count)
      end
    end
  end

  describe "GET edit" do
    before do
      get :edit, params: { id: info.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the info' do
      expect(assigns(:info)).to eq(info)
    end
    it "should render the form elements" do
      expect(page).to have_field('info_title', with: info.title)
      expect(page).to have_field('info_content', with: info.content)
      expect(page).to have_select('info_author_id', with_options: [info.author.email])
      expect(page).to have_select('info_category', with_options: [info.category.text])
    end
  end

  describe "PUT update" do
    context 'with valid params' do
      before do
        put :update, params: { id: info.id, info: valid_attributes }
      end
      it 'assigns the info' do
        expect(assigns(:info)).to eq(info)
      end
      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_info_path(info))
      end
      it "should update the info" do
        info.reload

        expect(info.title).to eq(valid_attributes["title"])
        expect(info.content).to eq(valid_attributes["content"])
      end
    end
    context 'with invalid params' do
      it 'returns http success' do
        put :update, params: { id: info.id, info: invalid_attributes }
        expect(response).to have_http_status(:success)
      end
      it 'does not change info' do
        expect {
          put :update, params: { id: info.id, info: invalid_attributes }
        }.not_to change(info.reload.title, :methods)
      end
    end
  end

  describe "GET show" do
    before do
      get :show, params: { id: info.id }
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the info' do
      expect(assigns(:info)).to eq(info)
    end
    it "should render the form elements" do
      expect(page).to have_content(info.title)
      expect(page).to have_content(info.content)
      expect(page).to have_content(info.author.display_name)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested select_option" do
      expect {
        delete :destroy, params: { id: info.id }
      }.to change(Info, :count).by(-1)
    end

    it "redirects to the index" do
      delete :destroy, params: { id: info.id }
      expect(response).to redirect_to(admin_infos_path)
    end
  end
end
