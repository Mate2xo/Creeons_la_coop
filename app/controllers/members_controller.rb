class MembersController < ApplicationController
  before_action :authenticate_member!
  def index
  end

  def show
  end

  def edit
    redirect_to members_path if current_member.id != params[:id].to_i
  end
end
