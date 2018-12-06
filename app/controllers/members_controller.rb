class MembersController < ApplicationController
  before_action :authenticate_member!
  def index
  end

  def show
  end

  def edit
	if current_member.id == params[:id].to_i || current_member.role == "super_admin"
	else
		redirect_to members_path 
  	end
  end
end
