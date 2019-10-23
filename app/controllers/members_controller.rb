# frozen_string_literal: true

# The websites users. Their 'role' attributes determines if fhey're an unvalidated user, a member, admin or super-admmin
class MembersController < ApplicationController
  before_action :authenticate_member!
  before_action :set_member, only: %i[show edit update]

  def index
    @members = Member.includes(:address, :avatar_attachment)
  end

  def show; end

  def edit
    @member_address = @member.address || @member.build_address
  end

  def update
    if @member.update_attributes(permitted_params)
      flash[:notice] = t "activerecord.notices.messages.update_success"
      redirect_to @member
    else
      flash[:error] = t "activerecord.errors.messages.update_fail"
      redirect_to edit_member_path(@member.id)
    end
  end

  private

  def permitted_params
    params.require(:member).permit(:email, :first_name, :last_name, :group, :avatar, :phone_number, :biography, address_attributes: %i[postal_code city street_name_1 street_name_2 coordinates])
  end

  def set_member
    @member = authorize Member.find(params[:id])
  end
end
