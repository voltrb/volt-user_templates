module UserTemplates
  class LoginController < Volt::ModelController
    reactive_accessor :errors
    reactive_accessor :username
    reactive_accessor :password

    def login
      User.login(username, password).then do
        # Successful login
      end.fail do |errors|
        # Login fail
        self.errors = errors
      end
    end

  end
end
