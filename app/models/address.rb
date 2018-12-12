class Address < ApplicationRecord
    belongs_to :productor, optional: true
    belongs_to :member, optional: true
    has_and_belongs_to_many :missions

    before_save :assign_coordonnee, on: [:create, :update]
 
    validates :city, :postal_code, :street_name_1, presence: true



  	def assign_coordonnee
		require "addressable/uri"
		url = ""
		coordonnee = ""
		if self.postal_code
			url = self.postal_code + " " 
		end
		if self.city
			url = url + self.city + " "
		end
		if self.street_name_1
			url = url + self.street_name_1 + " "
		end
		if self.street_name_2
			url = url + self.street_name_2
		end
		if (address = Addressable::URI.parse(url).normalize.to_str) != (nil || "")
			response = RestClient.get ("https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "+france&key=" + Rails.application.credentials[:google_key] ), {accept: :json}
			response = JSON.parse(response.body)
			if response["status"] == "OK" && response["results"][0]
				lat = response["results"][0]["geometry"]["location"]["lat"]
				lng = response["results"][0]["geometry"]["location"]["lng"]
				coordonnee = "{lat: " + lat.to_s + " , lng: " + lng.to_s + "}"
			end
		end
		self.coordonnee = coordonnee
    end
end

