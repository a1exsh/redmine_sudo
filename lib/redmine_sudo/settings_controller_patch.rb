module RedmineSudo
  module SettingsControllerPatch
    def self.included(base)
      base.class_eval do
        alias_method_chain :plugin, :sudo
      end
    end

    def plugin_with_sudo
      if request.post? && params[:id] == 'redmine_sudo'
        params[:settings][:prompt] = (params[:settings][:prompt] == '1')
        params[:settings][:expires_in] = [0, params[:settings][:expires_in].to_i].max
      end
      plugin_without_sudo
    end
  end
end
