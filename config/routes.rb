ActionController::Routing::Routes.draw do |map|
  map.connect 'login_sudo',
    :controller => 'account', :action => 'prompt_sudo',
    :conditions => { :method => :get }

  map.connect 'login_sudo',
    :controller => 'account', :action => 'login_sudo',
    :conditions => { :method => :post }

  map.connect 'logout_sudo',
    :controller => 'account', :action => 'logout_sudo',
    :conditions => { :method => :get }
end
