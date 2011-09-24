require 'redmine'
require 'dispatcher'

Dispatcher.to_prepare :redmine_sudo do
  require_dependency 'project'
  require_dependency 'user'
  require_dependency 'application_controller'
  require_dependency 'account_controller'

  unless User.included_modules.include? RedmineSudo::UserPatch
    User.send(:include, RedmineSudo::UserPatch)
  end

  unless ApplicationController.included_modules.include? RedmineSudo::ApplicationControllerPatch
    ApplicationController.send(:include, RedmineSudo::ApplicationControllerPatch)
  end

  unless AccountController.included_modules.include? RedmineSudo::AccountControllerPatch
    AccountController.send(:include, RedmineSudo::AccountControllerPatch)
  end
end

Redmine::Plugin.register :redmine_sudo do
  name 'Redmine Sudo plugin'
  author 'Alex Shulgin <ash@commandprompt.com>'
  description 'A Redmine plugin to make admin users become super user before they can actually employ admin powers.'
  version '0.0.1'
  url 'http://github.com/commandprompt/redmine_sudo'
  #  author_url 'http://example.com/about'

  menu :account_menu, :become_superuser,
    { :controller => 'account', :action => 'login_sudo' },
    :before => :my_account,
    :caption => :become_superuser,
    :if => Proc.new { User.current.has_sudo? && !User.current.sudo? }

  menu :account_menu, :giveup_superuser,
    { :controller => 'account', :action => 'logout_sudo' },
    :before => :my_account,
    :caption => :giveup_superuser,
    :if => Proc.new { User.current.has_sudo? && User.current.sudo? }
end
