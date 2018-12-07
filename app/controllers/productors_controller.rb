class ProductorsController < ApplicationController
  before_action :authenticate_member!
  def index
  end

  def show
		require "addressable/uri"
		@valide = "addresse invalide"
		url = "7 rue de la haute pierre 78620"
		if (@address = Addressable::URI.parse(url).normalize.to_str) != ""
		response = RestClient.get ("https://maps.googleapis.com/maps/api/geocode/json?address=" + @address + "+france&key=" + Rails.application.credentials[:google_key] ), {accept: :json}
		response = JSON.parse(response.body)
		if response["status"] == "OK" && response["results"][0]
			@lat = response["results"][0]["geometry"]["location"]["lat"]
			@lng = response["results"][0]["geometry"]["location"]["lng"]
			puts @lat
			puts @lng
			@valide = "addresse valide"
		end
		@producteur = Productor.where(id: params[:id])
		end
  end



  def edit
	if current_member.role == "super_admin" || current_member.role == "admin"  
		@producteur = Productor.where(id: params[:id])
	else
		redirect_to productors_path 
  	end
  end
end
