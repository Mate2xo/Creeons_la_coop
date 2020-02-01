class EndSouscriptionNotification 
	def perform
		SendNotificationJob.perform_now 
	end
end
