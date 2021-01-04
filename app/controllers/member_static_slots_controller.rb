# frozen_string_literal: true

# Reset static slots' member
class MemberStaticSlotsController < ApplicationController
  before_action :authenticate_member!

  def destroy
    MemberStaticSlot.where(member_id: current_member.id).destroy_all
    redirect_to edit_member_path(current_member), notice: t('.reset_success')
  end
end
