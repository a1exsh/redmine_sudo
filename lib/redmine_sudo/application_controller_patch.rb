module RedmineSudo
  module ApplicationControllerPatch
    def self.included(base)
      base.send(:alias_method_chain, :find_current_user, :sudo)
    end

    def find_current_user_with_sudo
      sudo = session[:sudo]
      sudo_expires = sudo.blank? ? (session.delete(:sudo_expires); nil) :
        session[:sudo_expires]

      if sudo_expires.blank? || Time.now > sudo_expires
        session.delete(:sudo)
        session.delete(:sudo_expires)
      end

      find_current_user_without_sudo.tap do |user|
        user.sudo = session[:sudo] if user
      end
    end
  end
end
