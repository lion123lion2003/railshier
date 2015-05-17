class Principal < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}users#{table_name_suffix}"

  # account statuses
  STATUS_ANONYMOUS  = 0
  STATUS_ACTIVE     = 1
  STATUS_REGISTERED = 2
  STATUS_LOCKED     = 3

  LOGIN_LENGTH_LIMIT = 16
  MAIL_LENGTH_LIMIT  = 255

  SOURCE_LOCAL     = 0
  SOURCE_LDAP      = 1

end

