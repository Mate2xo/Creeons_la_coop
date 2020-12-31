# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MemberStaticSlot request', type: :request do
  let(:current_member) { create :member }

  before { sign_in current_member }

  it 'deletes all member_static_slots of the current member' do
    create_list :member_static_slot, 2, member: current_member

    delete member_static_slot_path(1)

    expect(current_member.reload.member_static_slots).to be_empty
  end
end
