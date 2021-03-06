class ApplicationController < ActionController::Base
	respond_to :html, :json
  protect_from_forgery with: :exception
  before_action :set_notification, if: -> { user_signed_in? }
  before_action :set_message, if: -> { user_signed_in? }
  private 
  def set_notification
    @notifications = current_user.notifications.includes(:actor).reverse
  end

  def set_message
    @conversations = current_user.conversations.includes(:receiver).limit(10)
  end
end
