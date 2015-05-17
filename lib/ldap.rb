require 'ldap/adapter'
require 'ldap/connection'

module LDAP
  # Allow logging
  mattr_accessor :ldap_logger
  @@ldap_logger = true

  # A path to YAML config file or a Proc that returns a
  # configuration hash
  mattr_accessor :ldap_config
  # @@ldap_config = "#{Rails.root}/config/ldap.yml"

  mattr_accessor :ldap_update_password
  @@ldap_update_password = true

  mattr_accessor :ldap_check_group_membership
  @@ldap_check_group_membership = false

  mattr_accessor :ldap_check_attributes
  @@ldap_check_role_attribute = false

  mattr_accessor :ldap_use_admin_to_bind
  @@ldap_use_admin_to_bind = false

  mattr_accessor :ldap_auth_username_builder
  @@ldap_auth_username_builder = Proc.new() {|attribute, login, ldap| "#{attribute}=#{login},#{ldap.base}" }

  mattr_accessor :ldap_ad_group_check
  @@ldap_ad_group_check = false


  class LdapException < Exception
  end

end

