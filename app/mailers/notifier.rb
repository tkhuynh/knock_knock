class Notifier < ApplicationMailer
	default from: 'no-reply@knock-knock.com', return_path: 'tkhuynh808@gmail.com'

	def reserved(student, meeting, ta)
		@student = student
		@meeting = meeting
		subject_text = "Reserved" + meeting.start_time.localtime.strftime(" meeting on %m-%d-%Y at %H:%M")
		mail( to: ta.email, subject: subject_text)
	end

end
