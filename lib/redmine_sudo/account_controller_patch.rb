module RedmineSudo
  module AccountControllerPatch
    def login_sudo
      if User.current.has_sudo?
        User.current.sudo = session[:sudo] = true
        session[:sudo_expires] = Time.now + 15.minutes
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
