module RedmineSudo
  module AccountControllerPatch
    def login_sudo
      if User.current.has_sudo?
        User.current.sudo = session[:sudo] = true
        expires_in = Setting['plugin_redmine_sudo']['expires_in']
        expires_in = expires_in > 0 ? expires_in.minutes : 1.year
        session[:sudo_expires] = Time.now + expires_in
      end
      flash[:notice] = l(:notice_sudo_logged_in)
      redirect_to :back
    rescue RedirectBackError
      redirect_to home_path
    end

    def logout_sudo
      session.delete(:sudo)
      session.delete(:sudo_expires)
      flash[:notice] = l(:notice_sudo_logged_out)
      redirect_to :back
    rescue RedirectBackError
      redirect_to home_path
    end
  end
end
