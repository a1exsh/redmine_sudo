module RedmineSudo
  module UserPatch
    def has_sudo?
      read_attribute(:admin)
    end

    def admin?
      super && sudo?
    end

    def sudo?
      @sudo
    end

    def sudo=(val)
      @sudo = val
    end
  end
end
