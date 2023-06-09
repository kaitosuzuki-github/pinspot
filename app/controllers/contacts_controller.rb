class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.with(contact: @contact).contact_mail.deliver_now
      flash[:notice] = "お問い合わせを受け付けました"
      redirect_back(fallback_location: root_path)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :subject, :message)
  end
end
