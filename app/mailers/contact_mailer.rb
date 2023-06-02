class ContactMailer < ApplicationMailer
  def contact_mail
    @contact = params[:contact]
    mail from: email_address_with_name("support@example.com", "Pinspotサポート"), to: @contact.email,
         subject: '【お問い合わせ】' + @contact.subject
  end
end
