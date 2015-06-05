module UserTemplates
  class AccountController < Volt::ModelController
    before_action :require_login

    def index
      self.model = Volt.current_user.then(&:buffer)
    end

    def save
      model.save! do
        flash._notices << 'Account settings saved'
        redirect_to '/'
      end
    end
  end
end
