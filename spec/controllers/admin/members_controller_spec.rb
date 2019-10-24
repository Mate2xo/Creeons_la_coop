# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::MembersController, type: :controller do
  # this lets us inspect the rendered results
  render_views

  let(:page) { Capybara::Node::Simple.new(response.body) }
  before { sign_in create(:member, :super_admin) }

  let!(:member) { create(:member) }

  let(:valid_attributes) { attributes_for(:member) }

  let(:invalid_attributes) { { first_name: '' } }

  describe "GET index" do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
    it 'assigns the member' do
      get :index
      expect(assigns(:members)).to include(member)
    end
    it "should render the expected columns" do
      get :index
      expect(page).to have_content(member.first_name)
      expect(page).to have_content(member.last_name)
      expect(page).to have_content(member.email)
      expect(page).to have_content(member.role)
    end
  end

  describe "GET new" do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
    it 'assigns the member' do
      get :new
      expect(assigns(:member)).to be_a_new(Member)
    end
    it "should render the form elements" do
      get :new
      expect(page).to have_field(Member.human_attribute_name(:first_name))
      expect(page).to have_field(Member.human_attribute_name(:last_name))
      expect(page).to have_field(Member.human_attribute_name(:email))
      expect(page).to have_field(Member.human_attribute_name(:group))
      expect(page).to have_field(Member.human_attribute_name(:phone_number))
      expect(page).to have_field(Member.human_attribute_name(:biography))
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "creates a new Member" do
        expect {
          post :create, params: { member: valid_attributes }
        }.to change(Member, :count).by(1)
      end

      it "assigns a newly created person as @person" do
        post :create, params: { member: valid_attributes }
        expect(assigns(:member)).to be_a(Member)
        expect(assigns(:member)).to be_persisted
      end

      it "redirects to the created member" do
        post :create, params: { member: valid_attributes }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_member_path(Member.last))
      end

      it 'should create the member' do
        post :create, params: { member: valid_attributes }
        member = Member.last

        expect(member.first_name).to eq(valid_attributes[:first_name])
        expect(member.last_name).to  eq(valid_attributes[:last_name])
        expect(member.email).to      eq(valid_attributes[:email])
      end
    end

    context "with invalid params" do
      it 'invalid_attributes return http success' do
        post :create, params: { member: invalid_attributes }
        expect(response).to have_http_status(:success)
      end

      it "assigns a newly created but unsaved member as @member" do
        post :create, params: { member: invalid_attributes }
        expect(assigns(:member)).to be_a_new(Member)
      end

      it 'invalid_attributes do not create a Member' do
        expect do
          post :create, params: { member: invalid_attributes }
        end.not_to change(Member, :count)
      end
    end
  end

  describe "GET edit" do
    before { get :edit, params: { id: member.id } }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the member' do
      expect(assigns(:member)).to eq(member)
    end
    it "should render the form elements" do
      expect(page).to have_field(Member.human_attribute_name(:first_name), with: member.first_name)
      expect(page).to have_field(Member.human_attribute_name(:last_name), with: member.last_name)
      expect(page).to have_field(Member.human_attribute_name(:email), with: member.email)
    end
  end

  describe "PUT update" do
    context 'with valid params' do
      before { put :update, params: { id: member.id, member: valid_attributes } }

      it 'assigns the member' do
        expect(assigns(:member)).to eq(member)
      end
      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_member_path(member))
      end
      it "should update the member" do
        member.reload
        expect(member.last_name).to  eq(valid_attributes[:last_name])
        expect(member.first_name).to eq(valid_attributes[:first_name])
        expect(member.biography).to eq(valid_attributes[:biography])
        expect(member.phone_number).to eq(valid_attributes[:phone_number])
        expect(member.group).to eq(valid_attributes[:group])
      end
    end
    context 'with invalid params' do
      it 'returns http success' do
        put :update, params: { id: member.id, member: invalid_attributes }
        expect(response).to have_http_status(:success)
      end
      it 'does not change member' do
        expect {
          put :update, params: { id: member.id, member: invalid_attributes }
        }.not_to change(member.reload.first_name, :methods)
      end
    end
  end

  describe "GET show" do
    before { get :show, params: { id: member.id } }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the member' do
      expect(assigns(:member)).to eq(member)
    end
    it "should render the form elements" do
      expect(page).to have_content(member.last_name)
      expect(page).to have_content(member.first_name)
      expect(page).to have_content(member.email)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested select_option" do
      expect {
        delete :destroy, params: { id: member.id }
      }.to change(Member, :count).by(-1)
    end

    it "redirects to the field" do
      delete :destroy, params: { id: member.id }
      expect(response).to redirect_to(admin_members_path)
    end

    context "when a member has created a ressource" do
      it " gets deleted even if the member has previously created an info" do
        create(:info, author_id: member.id)
        expect {
          delete :destroy, params: { id: member.id }
        }.to change(Member, :count).by(-1)
      end
    end
  end
end
