# frozen_string_literal: true

# The websites users. Their 'role' attributes determines if fhey're an unvalidated user, a member, admin or super-admmin
class MembersController < ApplicationController
  before_action :authenticate_member!
  before_action :set_member

  def index
    @members = Member.all
  end

  def show; end

  def edit
    redirect_to "/members" unless current_member.id == params[:id].to_i || super_admin?

    @member_address = @member.address || @member.build_address
  end

  def update
    redirect_to "/members" unless current_member.id == params[:id].to_i || super_admin?

    if @member.update_attributes(permitted_params)
      flash[:notice] = "Votre profil a été mis à jour"
      redirect_to @member
    else
      flash[:error] = "Une erreur est survenue, l'opération a été annulée"
      redirect_to edit_member_path(@member.id)
    end
  end

  private

  def permitted_params
    params.require(:member).permit(:email, :first_name, :last_name, :avatar, :phone_number, address_attributes: %i[postal_code city street_name_1 street_name_2 coordonnee])
  end

  def set_member
    @member = Member.find(params[:id])
  end
end
