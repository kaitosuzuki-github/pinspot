# Preview all emails at http://localhost:3000/rails/mailers/devise
class DevisePreview < ActionMailer::Preview
  def confirmation_instructions
    DeviseMailer.confirmation_instructions(User.first, "faketoken", {})
  end

  def reset_password_instructions
    DeviseMailer.reset_password_instructions(User.first, "faketoken", {})
  end
end
