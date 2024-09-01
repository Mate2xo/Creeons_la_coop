require 'rails_helper'

RSpec.describe 'admin/members' do
  before { sign_in build_stubbed(:member, :super_admin) }

  describe 'GET /' do
    subject(:index) { get admin_members_path }

    let!(:members) { [create(:member)] }

    it 'has an :ok HTTP status' do
      index
      expect(response).to have_http_status(:ok)
    end

    %i[first_name last_name email role cash_register_proficiency].each do |attribute|
      it 'renders the expected columns' do
        index
        expect(response.body).to include(members.first.send(attribute))
      end
    end

    context 'with the .csv format' do
      subject(:csv_index) { get admin_members_path, params: {format: :csv} }

      it 'has an :ok HTTP status' do
        csv_index
        expect(response).to have_http_status(:ok)
      end

      it 'returns a CSV format' do
        csv_index
        expect(response.header['Content-Type']).to include 'text/csv'
      end
    end
  end

  describe 'GET /:id' do
    subject(:show) { get admin_member_path(member) }

    let(:member) { create(:member) }

    it 'has an :ok HTTP status' do
      show
      expect(response).to have_http_status(:ok)
    end

    context 'when the member belongs to a group' do
      let(:member) { create(:group, :with_members_and_managers).members.first }

      it 'has an :ok HTTP status' do
        show
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with static slots selection history' do
      let(:member) { create(:history_of_static_slot_selection).member }

      it 'has an :ok HTTP status' do
        show
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /new' do
    subject(:new) { get new_admin_member_path }

    it 'has an :ok HTTP status' do
      new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /' do
    subject(:create_member) { post admin_members_path, params: params }

    let(:params) do
      {member: attributes_for(:member, cash_register_proficiency: 'beginner', email: 'update@update.com')}
    end

    it 'creates a Member' do
      expect { create_member }.to change(Member, :count).by(1)
    end

    it 'redirects to the created member' do
      create_member
      expect(response).to redirect_to(admin_member_path(Member.last))
    end

    context 'with invalid params' do
      let(:params) do
        {member: {first_name: nil}}
      end

      it 'does not create any Member' do
        expect { create_member }.not_to change(Member, :count)
      end

      it 'renders the :new form again' do
        create_member
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET /:id/edit' do
    subject(:edit) { get edit_admin_member_path(member) }

    let(:member) { create(:member) }

    it 'has an :ok HTTP status' do
      edit
      expect(response).to have_http_status(:ok)
    end

    context 'when the member belongs to a group' do
      let(:member) { create(:group, :with_members_and_managers).members.first }

      it 'has an :ok HTTP status' do
        edit
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PUT /:id' do
    subject(:update) { put admin_member_path(member), params: params }
    
    let(:member) { create(:member, first_name: 'patate') }
    let(:params) { {member: {first_name: 'potato'}} }

    it 'updates the user with the given params' do
      expect { update }.to change { member.reload.first_name }.from('patate').to('potato')
    end

    it 'redirects to the member show page' do
      update
      expect(response).to redirect_to(admin_member_path(member))
    end

    context 'with invalid params' do
      let(:params) { {member: {first_name: nil}} }

      it 'does not update the member' do
        expect { update }.not_to(change { member.reload.first_name })
      end
    end
  end

  describe 'POST /enroll_static_members' do
    subject(:enroll_static_members) { post enroll_static_members_admin_members_path }

    it 'launches an EnrollStaticMembersJob worker' do
      expect { enroll_static_members }.to have_enqueued_job(EnrollStaticMembersJob)
    end
  end

  describe 'PUT /remove_static_slots_of_a_member' do
    subject(:remove_static_slots_of_a_member) { put remove_static_slots_of_a_member_admin_members_path, params: params }

    let(:params) { {member_id: member.id} }
    let(:member) { create(:member_static_slot).member }

    it 'deletes all static slots associated to the given member' do
      expect { remove_static_slots_of_a_member }.to change(member.member_static_slots, :count).from(1).to(0)
    end
  end
end
