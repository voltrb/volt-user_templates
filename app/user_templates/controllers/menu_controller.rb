module UserTemplates
  class MenuController < Volt::ModelController
    def show_name
      Volt.current_user.then do |user|
        # Make sure there is a user
        if user
          user._name || user._email || user._username
        else
          ''
        end
      end
    end

    def is_active?
      url.path.split('/')[1] == 'login'
    end
  end
end