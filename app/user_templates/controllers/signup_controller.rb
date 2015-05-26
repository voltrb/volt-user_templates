module UserTemplates
  class SignupController < Volt::ModelController
    def index
      self.model = store._users.buffer
    end

    def signup
      # Get login and password to login
      login = model.send(:"_#{User.login_field}")
      password = model._password

      save!.then do |result|
        flash._notices << "Signup successful"

        # On a successful signup, then login
        Volt.login(login, password).then do
          after_signup
        end.fail do |errors|
          # Show the error (probably only the server goes down)
          flash._errors << errors.to_s
        end
      end.fail do |err|
        puts "ERR: #{err.inspect}"
      end
    end

    def after_signup
      post_signup_url = attrs.post_signup_url || '/'

      # Redirect to post signup url
      redirect_to post_signup_url
    end

    def use_username?
      Volt.config.public.try(:auth).try(:use_username)
    end

  end
end
