class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("from@example.com", "Pinspot")
  layout "mailer"
end
