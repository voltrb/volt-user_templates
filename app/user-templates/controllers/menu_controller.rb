module UserTemplates
  class MenuController < Volt::ModelController
    def show_name
      user = Volt.current_user
      user._name.or(user._email).or(user._username)
    end
  end
end