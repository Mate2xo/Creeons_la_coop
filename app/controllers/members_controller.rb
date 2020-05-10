# frozen_string_literal: true

# The websites users. Their 'role' attributes determines if fhey're an unvalidated user, a member, admin or super-admmin
class MembersController < ApplicationController
  before_action :authenticate_member!
  before_action :set_authorized_member, only: %i[show edit update]

  def index
    @members = Member.includes(:address, :avatar_attachment).order(last_name: :asc)
  end

  def show; end

  def edit
    @member.build_address if @member.address.blank?
  end

  def update
    if @member.update(permitted_params)
      flash[:notice] = t 'activerecord.notices.messages.update_success'
      render :show
    else
      flash[:error] = t 'activerecord.errors.messages.update_fail'
      render :edit
    end
  end

  private

  def permitted_params
    params.require(:member).permit(
      :email, :first_name, :last_name, :group,
      :avatar, :phone_number, :biography,
      :cash_register_proficiency,
      address_attributes: %i[
        id postal_code city street_name_1 street_name_2 _destroy
      ]
    )
  end

  def set_authorized_member
    @member = authorize Member.find(params[:id])
  end
end
