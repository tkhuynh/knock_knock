class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@knock-knock.com"
  layout 'mailer'
end
