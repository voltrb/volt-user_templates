require 'user_templates/lib/password_reset_token'

class UserTemplateTasks < Volt::Task
  def send_reset_email(email)
    # Find user by e-mail
    Volt.skip_permissions do
      store._users.where(email: email).first.then do |user|
        if user
          reset_token = UserTemplates::PasswordResetToken.for_user(user.id)

          reset_url, _ = url_for(
            component: 'user_templates',
            controller: 'password_reset',
            action: 'index',
            user_id: user.id,
            token: reset_token
          )

          Mailer.deliver('user_templates/mailers/forgot',
            {to: email, name: user._name, reset_url: reset_url}
          )

          nil
        else
          raise "There is no account with the e-mail of #{email}."
        end
      end
    end
  end
end