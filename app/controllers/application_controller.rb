class ApplicationController < ActionController::Base
	respond_to :html, :json
  protect_from_forgery with: :exception
  before_action :set_notification, if: -> { user_signed_in? }
  private 
  def set_notification
    @notifications = current_user.notifications.reverse
  end
end
