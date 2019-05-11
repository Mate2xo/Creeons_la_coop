require 'rails_helper'

RSpec.describe MissionsController, type: :controller do
  let(:member) { create :member }
  let(:mission) { create :mission }

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

    describe "GET edit" do
      let(:authored_mission) { create :mission, author: member}
      before { get :edit, params: { id: authored_mission.id } }

      it { expect(response).to have_http_status :success }
      it { expect(assigns(:mission)).to eq(authored_mission) }
    end
  end


end
