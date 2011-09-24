module RedmineSudo
  module ApplicationControllerPatch
    def self.included(base)
      base.send(:alias_method_chain, :find_current_user, :sudo)
    end

    def find_current_user_with_sudo
      find_current_user_without_sudo.tap do |user|
        user.sudo = true if user && session[:sudo]
      end
    end
  end
end
