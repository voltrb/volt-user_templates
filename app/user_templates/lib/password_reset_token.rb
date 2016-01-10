require 'digest'

module UserTemplates
  module PasswordResetToken
    def self.for_user(user_id, time_offset=0)
      # Get a token with the hour as part of the hash.
      time_num = time_offset.hours.ago.beginning_of_hour.to_i

      Digest::SHA256.hexdigest("#{user_id}||#{Volt.config.app_secret}||#{time_num}")
    end

    # Checks for the current hour or the previous for the valid token
    def self.valid_token_for_user?(user_id, token)
      if for_user(user_id, 0) == token
        true
      elsif for_user(user_id, 1) == token
        true
      else
        false
      end
    end
  end
end
