module UserTemplates
  class LoginController < Volt::ModelController
    reactive_accessor :errors
    reactive_accessor :login
    reactive_accessor :password
    reactive_accessor :reset_email

    def do_login
      Volt.login(login, password).then do
        # Successful login, clear out the form
        self.errors = nil
        self.login = ''
        self.password = ''

        redirect_to(attrs.post_login_url || params._post_login_url || '/')

        nil
      end.fail do |errors|
        # Login fail
        self.errors = errors
      end
    end

    def forgot_url
      url_for(component: 'user_templates', controller: 'login', action: 'forgot')
    end

    def send_reset_email
      UserTemplateTasks.send_reset_email(reset_email).then do
        self.reset_email = ''
        flash._notices << 'Reset email sent.'
        redirect_to(attrs.post_forgot_url || params._post_forgot_url || '/login')
      end.fail do |err|
        flash._errors << err.to_s
      end
    end

    def use_username?
      Volt.config.public.try(:auth).try(:use_username)
    end

  end
end
