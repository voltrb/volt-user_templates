require 'user_templates/lib/password_reset_token'

class PasswordResetTasks < Volt::Task
  def reset_password(user_id, token, new_password)
    valid = UserTemplates::PasswordResetToken.valid_token_for_user?(user_id, token)

    if valid
      Volt.skip_permissions do
        user = store.users.where(id: user_id).first.sync.buffer

        user.password = new_password
        user.save!.then do
          login_as(user)
          nil
        end
      end
    else
      raise "The password reset link has expired."
    end
  end
end