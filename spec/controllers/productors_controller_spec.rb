require 'rails_helper'

RSpec.describe ProductorsController, type: :controller do
  let(:member) { create(:member) }
  let(:super_admin) { create(:member, :super_admin) }
  let!(:productor) { create(:productor) }

  let(:valid_attributes) { attributes_for(:productor) }
  let(:invalid_attributes) do { name: '' } end

  context "as a member" do
    before { sign_in member }

    describe "GET index" do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'assigns the productor' do
        get :index
        expect(assigns(:productors)).to include(productor)
      end
    end

    describe "GET show" do
      subject { get :show, params: { id: productor.id } }

      it { is_expected.to have_http_status :success }
      it 'assigns the productor' do
        subject
        expect(assigns(:productor)).to eq(productor)
      end
    end

    describe "authorization redirections" do
      it "redirects a member trying to access #new" do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
  end
  
  context "as a super_admin" do
    before { sign_in super_admin }

    describe "GET new" do
      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
      end

      it 'assigns the productor' do
        get :new
        expect(assigns(:productor)).to be_a_new(Productor)
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
          expect(response).to redirect_to(productor_path(Productor.last))
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
          expect(response).to redirect_to(productor_path(productor))
        end
        it "update the attributes" do
          productor.reload

          expect(productor.name).to eq(valid_attributes[:name])
          expect(productor.description).to eq(valid_attributes[:description])
          expect(productor.phone_number).to eq(valid_attributes[:phone_number])
          expect(productor.website_url).to eq(valid_attributes[:website_url])
        end
      end

      context 'with invalid params' do
        it 'redirect to the edit form' do
          put :update, params: { id: productor.id, productor: invalid_attributes }
          expect(response).to redirect_to(edit_productor_path)
        end

        it 'does not change productor' do
          expect do
            put :update, params: { id: productor.id, productor: invalid_attributes }
          end.not_to change(productor.reload.name, :methods)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested select_option" do
        expect {
          delete :destroy, params: { id: productor.id }
        }.to change(Productor, :count).by(-1)
      end

      it "redirects to the index" do
        delete :destroy, params: { id: productor.id }
        expect(response).to redirect_to(productors_path)
      end
    end
    
  end
  
end
