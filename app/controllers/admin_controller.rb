class AdminController < ApplicationController
	def show
		if member_signed_in? && current_member.role == "super_admin"
		else
			redirect_to "/"
		end
	end

end
