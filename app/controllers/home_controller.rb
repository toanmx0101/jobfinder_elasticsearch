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

  def setting
  	
  end

  def appropriate_jobs
    @appropricate_jobs = Article.search(current_user.work_position).records
  end
end
