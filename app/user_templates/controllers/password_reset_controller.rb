module UserTemplates
  class PasswordResetController < Volt::ModelController
    reactive_accessor :user, :errors

    def index
      self.user = store.users.buffer
      user.password = ''
    end

    def reset_password
      self.errors = nil
      user.mark_all_fields!
      user.validate!.fail do |errs|
        # .validate! changed with the sql branch, so we support both versions
        # here
        unless errs[:password]
          PasswordResetTasks.reset_password(params._user_id, params._token, user.password).then do
            flash._notices << 'Password updated'
            user.password = ''

            redirect_to '/'
          end.fail do |err|
            self.errors = err
          end
        end
      end
    end
  end
end
