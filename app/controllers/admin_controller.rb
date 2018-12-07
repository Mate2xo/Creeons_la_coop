class AdminController < ApplicationController
	def show
		if member_signed_in? && current_member.role == "super_admin"
		else
			redirect_to "/"
		end
	end

	def destroy
		if params[:class] == "member" &&  member_signed_in? && current_member.role == "super_admin"
	    Member.destroy(params[:id])
		elsif params[:class] == "info" &&  member_signed_in? && current_member.role == "super_admin"
	    Info.destroy(params[:id])	    	
		elsif params[:class] == "mission" &&  member_signed_in? && current_member.role == "super_admin"
	    Mission.destroy(params[:id])	
		elsif params[:class] == "productor" &&  member_signed_in? && current_member.role == "super_admin"
	    Productor.destroy(params[:id])	
		end
		flash[:success] = params[:class].to_s + " a bien été supprimé"
	end

	def role 
		if member_signed_in? && current_member.role == "super_admin"
 			Member.where(id: params[:id]).update(:role => params[:role])
 			flash[:success] = "l'utilisateur a bien changer de role"
		end
	end
end
