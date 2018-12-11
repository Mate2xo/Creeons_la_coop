class MembersController < ApplicationController
  before_action :authenticate_member!

  def index
    @members = Member.all
  end

  def show
    @member = Member.where(id: params[:id]) 
  end

  def edit
    if current_member.id == params[:id].to_i || current_member.role == "super_admin"
      @member = Member.find(params[:id])
    else
      redirect_to members_path
    end
  end

  def update
    @member = Member.find(params[:id])
      if @member.update_attributes(permitted_params)
        flash[:success] = "Member was successfully updated"
        redirect_to @member
      else
        flash[:error] = "Something went wrong"
        render 'edit'
      end
  end

  private

  def permitted_params
    params.require(:member).permit(:email, :first_name, :last_name, :avatar)
  end
end
