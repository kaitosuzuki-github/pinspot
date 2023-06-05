class DeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: 'user/mailer'

  def confirmation_instructions(record, token, opts = {})
    opts[:from] = email_address_with_name("from@example.com", "Pinspot")
    opts[:reply_to] = nil
    super
  end
end
