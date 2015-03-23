module UserTemplates
  class MenuController < Volt::ModelController
    def show_name
      Volt.fetch_user.then do |user|
        user._name.or(user._email).or(user._username)
      end
    end
  end
end