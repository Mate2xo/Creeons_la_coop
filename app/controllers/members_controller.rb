class MembersController < ApplicationController
  before_action :authenticate_member!
  def index
    @members = Member.all
  end

  def show
    @member = Member.find(params[:id])
  end

  def edit
    redirect_to members_path if current_member.id != params[:id].to_i
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      flash[:success] = "Bienvenue "
      redirect_to @member
    else
      render 'new'
    end
  end

end
