module RedmineSudo
  module AccountControllerPatch
    def login_sudo
      User.current.sudo = session[:sudo] = true if User.current.has_sudo?
      redirect_to :back
    rescue RedirectBackError
      redirect_to home_path
    end

    def logout_sudo
      session[:sudo] = false
      redirect_to :back
    rescue RedirectBackError
      redirect_to home_path
    end
  end
end
