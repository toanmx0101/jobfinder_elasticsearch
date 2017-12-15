class HomeController < ApplicationController
  def index
    if user_signed_in?
      render :dashboard
    end
  end

  def message_thread
    
  end

  def user_profile

  end
end
