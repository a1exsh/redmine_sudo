module RedmineSudo
  module AccountControllerPatch
    def self.included(base)
      base.class_eval do
        before_filter :require_user_has_sudo,
          :only => [:prompt_sudo, :login_sudo]
      end
    end

    def prompt_sudo
      if User.current.sudo?
        redirect_to :back
      elsif !sudo_settings['prompt']
        login_sudo
      end
    rescue ActionController::RedirectBackError
      redirect_to home_path
    end

    def login_sudo
      if sudo_settings['prompt'] && !User.try_to_login(User.current.login,
                                                       params[:password])
        flash.now[:error] = l(:notice_account_invalid_creditentials)
        render :prompt_sudo
        return
      end
      
      User.current.sudo = session[:sudo] = true

      expires_in = sudo_settings['expires_in']
      expires_in = expires_in > 0 ? expires_in.minutes : 1.year
      session[:sudo_expires] = Time.now + expires_in

      flash[:notice] = l(:notice_sudo_logged_in)
      if sudo_settings['prompt']
        redirect_back_or_default home_path
      else
        redirect_to :back
      end
    rescue ActionController::RedirectBackError
      redirect_to home_path
    end

    def logout_sudo
      session.delete(:sudo)
      session.delete(:sudo_expires)
      if User.current.sudo?
        User.current.sudo = false
        flash[:notice] = l(:notice_sudo_logged_out)
      end
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to home_path
    end

    private

    def require_user_has_sudo
      deny_access unless User.current.has_sudo?
    end

    def sudo_settings
      Setting['plugin_redmine_sudo']
    end
  end
end
