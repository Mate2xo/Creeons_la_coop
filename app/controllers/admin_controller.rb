# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_member!

  def show
    return redirect_to "/" unless super_admin?

    @members = Member.all
    @infos = Info.all
    @missions = Mission.all
    @productors = Productor.all
  end

  def destroy
    return redirect_to "/" unless super_admin?

    case params[:class]
    when 'member' then Member.destroy(params[:id])
    when 'info' then Info.destroy(params[:id])
    when 'mission' then Mission.destroy(params[:id])
    when 'productor' then Productor.destroy(params[:id])
    end
    flash[:success] = params[:class].to_s + " a bien été supprimé"
    redirect_to admin_path
  end

  def role
    return redirect_to "/" unless super_admin?

    Member.where(id: params[:id]).update(role: params[:role])
    flash[:success] = "l'utilisateur a bien changé de rôle"
  end
end
