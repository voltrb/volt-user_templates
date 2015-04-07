module UserTemplates
  class MenuController < Volt::ModelController
    def show_name
      Volt.fetch_current_user.then do |user|
        user._name || user._email || user._username
      end
    end
  end
end