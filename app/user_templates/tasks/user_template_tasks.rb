class UserTemplateTasks < Volt::Task
  def send_reset_email(email)
    # Find user by e-mail
    Volt.skip_permissions do
      store._users.where(email: email).fetch_first do |user|
        if user
          Mailer.deliver('user_templates/mailers/forgot', {to: email, name: user._name})
        else
          raise "There is no account with the e-mail of #{email}."
        end
      end
    end
  end
end