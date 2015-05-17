
class Unauthorized < Exception; end

class ApplicationController < ActionController::Base
  include Pundit
  before_filter :user_setup

  respond_to :html, :xml, :js

  protect_from_forgery
  rescue_from Pundit::NotAuthorizedError, with: :pundit_not_authorized

  def render_403(options={})
    @project = nil
    render_error({:message => :notice_not_authorized, :status => 403}.merge(options))
    return false
  end

  def render_404(options={})
    render_error({:message => :notice_file_not_found, :status => 404}.merge(options))
    return false
  end

  # Renders an error response
  def render_error(arg)
    arg = {:message => arg} unless arg.is_a?(Hash)

    @message = arg[:message]
    @message = t(@message) if @message.is_a?(Symbol)
    @status = arg[:status] || 500

    respond_with(@message, @status) do |format|
      format.html {
        render :template => 'common/error', :layout => use_layout, :status => @status
      }
      format.any { head @status }
    end
  end

  def use_layout
    request.xhr? ? false : 'application'
  end

  def require_login
    return authenticate_user!
  end

  def require_admin
    return false unless require_login
    if !current_user.admin?
      render_403
      return false
    end
    true
  end

  def pundit_not_authorized(exception)
    render_403
  end

  def user_setup
    User.current = user_signed_in? ? current_user : nil
  end

end
