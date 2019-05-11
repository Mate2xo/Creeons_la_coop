require 'rails_helper'

RSpec.describe MissionsController, type: :controller do
  let(:member) { create :member }
  let(:super_admin) { create :member, :super_admin }
  let(:mission) { create :mission }
  let(:valid_attributes) { attributes_for(:mission) }
  let(:invalid_attributes) do { name: ''} end

  context "as a member" do
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

    describe "Update an authored mission" do
      let(:authored_mission) { create :mission, author: member}

      context "when accessing #edit" do
        before { get :edit, params: { id: authored_mission.id } }
  
        it { expect(response).to have_http_status :success }
        it { expect(assigns(:mission)).to eq(authored_mission) }
      end

      context "when accessing #update" do
        context 'with valid params' do
          before { put :update, params: { id: authored_mission.id, mission: valid_attributes } }
  
          it { expect(assigns(:mission)).to eq(authored_mission) }
          it { expect(response).to have_http_status(:redirect) }
          it { expect(response).to redirect_to(mission_path(authored_mission)) }

          it "update the attributes" do
            authored_mission.reload
            expect(authored_mission.name).to eq(valid_attributes[:name])
            expect(authored_mission.description).to eq(valid_attributes[:description])
          end
        end
  
        context 'with invalid params' do
          it 'redirect to the edit form' do
            put :update, params: { id: authored_mission.id, mission: invalid_attributes }
            expect(response).to redirect_to(edit_mission_path(authored_mission.id))
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
      mission
    }

    it "can edit any mission" do
      get :edit, params: {id: mission.id}
      expect(response).to have_http_status(:success) 
    end

    it "can update any mission" do
      put :update, params: {id: mission.id, mission: valid_attributes }
      expect(mission.reload.name).to eq(valid_attributes[:name])
    end

    it "can destroy any mission" do
      expect {
          delete :destroy, params: { id: mission.id }
        }.to change(Mission, :count).by(-1)
    end
  end
end
