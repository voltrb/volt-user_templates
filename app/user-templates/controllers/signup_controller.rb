module UserTemplates
  class SignupController < Volt::ModelController
    def index
      self.model = store._users.buffer
    end

    def signup
      save!.then do |result|
        flash._notices << "Signup successful"

        post_signup_url = attrs.post_signup_url.or('/')

        go post_signup_url
      end.fail do |err|
        puts "ERR: #{err.inspect}"
      end
    end

    def use_username?
      auth = Volt.config.auth
      auth && auth.use_username
    end

  end
end
