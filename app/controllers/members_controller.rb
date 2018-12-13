# The websites users. Their 'role' attributes determines if fhey're an unvalidated user, a member, admin or super-admmin
class MembersController < ApplicationController
  before_action :authenticate_member!

  def index
    @members = Member.all
  end

  def show
    @member = Member.find(params[:id])
  end

  def edit
    if current_member.id == params[:id].to_i || current_member.role == "super_admin"
      @member = Member.find(params[:id])
      @member_address = @member.address || @member.build_address
    else
      redirect_to "/members"
    end
  end

  def update
    if current_member.id == params[:id].to_i || current_member.role == "super_admin"
      @member = Member.find(params[:id])
      if @member.update_attributes(permitted_params)
        flash[:notice] = "Votre profil a été mis à jour"
        redirect_to @member
      else
        flash[:error] = "Une erreur est survenue, l'opération a été annulée"
        redirect_to edit_member_path(@member.id)
      end
    else
    redirect_to "/members"
    end
  end

  private

  def permitted_params
    params.require(:member).permit(:email, :first_name, :last_name, :avatar)
  end
end
