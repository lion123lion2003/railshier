module LDAP
  class Logger    
    def self.send(message, logger = Rails.logger)
      if ::LDAP.ldap_logger
        logger.add 0, "  \e[36mLDAP:\e[0m #{message}"
      end
    end
  end

end
