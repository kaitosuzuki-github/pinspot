# Preview all emails at http://localhost:3000/rails/mailers/contact
class ContactPreview < ActionMailer::Preview
  def contact_mail
    ContactMailer.with(contact: Contact.last).contact_mail
  end
end
