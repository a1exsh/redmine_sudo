ActionController::Routing::Routes.draw do |map|
  map.signin_sudo 'login_sudo', :controller => 'account', :action => 'login_sudo'
  map.signout_sudo 'logout_sudo', :controller => 'account', :action => 'logout_sudo'
end
