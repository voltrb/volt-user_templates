class UserTemplateTasks < Volt::Task
  def send_reset_email(email)
    # Find user by e-mail
    Volt.skip_permissions do
      store._users.where(email: email).fetch_first do |user|
        Mailer.deliver('user_templates/mailers/forgot', {to: email, name: user._name}).then do
          true
        end
      end
    end

  end
end