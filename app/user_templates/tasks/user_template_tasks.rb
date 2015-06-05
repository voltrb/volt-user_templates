require 'digest'

class UserTemplateTasks < Volt::Task
  def send_reset_email(email)
    # Find user by e-mail
    Volt.skip_permissions do
      store._users.where(email: email).fetch_first do |user|
        if user
          reset_token = password_reset_token(user.id)

          reset_base_url = url_for(component: 'user_templates',
            controller: 'password_reset', action: 'index')

          reset_url = "http://#{Volt.config.domain}/#{reset_base_url}/?"
            + "user_id=#{user_id}&token=#{reset_token}"

          Mailer.deliver('user_templates/mailers/forgot',
            {to: email, name: user._name, reset_url: reset_url}
          )
        else
          raise "There is no account with the e-mail of #{email}."
        end
      end
    end
  end

  private
  def password_reset_token(user_id)
    Digest::SHA256.hexdigest("#{user_id}||#{Volt.config.app_secret}")
  end
end