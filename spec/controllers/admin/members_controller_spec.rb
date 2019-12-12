# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::MembersController, type: :controller do
  # this lets us inspect the rendered results
  render_views

  before { sign_in create(:member, :super_admin) }

  let(:page) { Capybara::Node::Simple.new(response.body) }
  let!(:member) { create(:member) }
  let(:valid_attributes) { attributes_for(:member) }
  let(:invalid_attributes) { { first_name: '' } }

  describe "GET index" do
    before { get :index }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the member' do
      expect(assigns(:members)).to include(member)
    end

    %i(first_name last_name email role cash_register_proficiency group).each do |attribute|
      it "renders the expected columns" do
        expect(page).to have_content(member.send(attribute))
      end
    end
  end

  describe "GET new" do
    before { get :new }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'assigns the member' do
      expect(assigns(:member)).to be_a_new(Member)
    end

    %i(
      first_name last_name email group phone_number cash_register_proficiency biography
    ).each do |attribute|
      it "should render the #{attribute} form" do
        expect(page).to have_field(Member.human_attribute_name(attribute))
      end
    end
  end

  describe "POST create" do
    context "with valid params" do
      before { post :create, params: { member: valid_attributes } }

      it "assigns @member" do
        expect(assigns(:member)).to be_a(Member)
      end

      it 'creates the member' do
        expect(assigns(:member)).to be_persisted
      end

      it "redirects to the created member" do
        expect(response).to redirect_to(admin_member_path(Member.last))
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
  end

  describe "PUT update" do
    context 'with valid params' do
      before { put :update, params: { id: member.id, member: valid_attributes } }

      it 'assigns the member' do
        expect(assigns(:member)).to eq(member)
      end
      it 'returns http redirect' do
        expect(response).to redirect_to(admin_member_path(member))
      end

      %i(
        first_name last_name group phone_number cash_register_proficiency biography
      ).each do |attribute|
        it "updates the #{attribute} attribute" do
          member.reload
          expect(member.reload.send(attribute)).to eq(valid_attributes[attribute])
        end
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
  end

  describe "DELETE #destroy" do
    it "destroys the requested select_option" do
      expect {
        delete :destroy, params: { id: member.id }
      }.to change(Member, :count).by(-1)
    end

    it "redirects to the members index" do
      delete :destroy, params: { id: member.id }
      expect(response).to redirect_to(admin_members_path)
    end

    context "when a member has created a ressource" do
      it "gets deleted even if the member has previously created an info" do
        create(:info, author_id: member.id)
        expect {
          delete :destroy, params: { id: member.id }
        }.to change(Member, :count).by(-1)
      end
    end
  end
end
