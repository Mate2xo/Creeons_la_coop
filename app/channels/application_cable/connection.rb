# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base # rubocop:disable Style/Documentation
    identified_by :current_member

    def connect
      self.current_member = find_verified_member
    end

    private

    def find_verified_member
      verified_user = env['warden'].user
      return reject_unauthorized_connection unless verified_user

      if verified_user.super_admin? || verified_user.admin?
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
