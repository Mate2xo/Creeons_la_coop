# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StaticSlotMembers request', type: :request do
  let(:current_member) { create :member }

  before { sign_in current_member }

  it 'deletes all static_slot_members of the current member' do
    static_slot_members = create_list :static_slot_member, 2, member: current_member

    delete static_slot_member_path(1)

    expect(current_member.reload.static_slot_members).to be_empty
  end
end
