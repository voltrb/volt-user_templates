module UserTemplates
  class UserController < Volt::ModelController
    def index
      go('/login') unless Volt.user?

      self.model = :store
    end

    def selected_user
      _users.find(_id: params._index).first
    end

    def use_username?
      Volt.config.public.try(:auth).try(:use_username)
    end
  end
end
