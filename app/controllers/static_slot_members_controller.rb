# frozen_string_literal: true

class StaticSlotMembersController < ApplicationController
  before_action :authenticate_member!

  def destroy
    StaticSlotMember.where(member_id: current_member.id).destroy_all
    redirect_to edit_member_path(current_member), notice: t('.reset_success')
  end

  private
end
