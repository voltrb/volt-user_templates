module UserTemplates
  class LoginController < Volt::ModelController
    reactive_accessor :errors
    reactive_accessor :login
    reactive_accessor :password

    def do_login
      Volt.login(login, password).then do
        # Successful login, clear out the form
        self.errors = nil
        self.login = ''
        self.password = ''

        go(attrs.post_login_url.or('/'))

        nil
      end.fail do |errors|
        # Login fail
        self.errors = errors
      end
    end

    def use_username?
      auth = Volt.config.auth
      auth && auth.use_username
    end

  end
end
