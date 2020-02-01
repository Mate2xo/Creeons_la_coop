class EndSouscriptionNotification 
	def perform

		n = Time.now
		start = Time.new(n.year, n.month, n.day, 23, 30)

		schedule = IceCube::Schedule.new(start)
		schedule.add_recurrence_rule IceCube::Rule.daily
		singleton.each do
			#SendNotificationJob.perform_now 
		end
	end
end
