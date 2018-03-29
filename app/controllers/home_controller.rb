class HomeController < ApplicationController
  def index
    if user_signed_in?
      @jobs = current_user.jobs
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
    @appropricate_jobs = Job.search(current_user.work_position + " " + current_user.description + " " + current_user.specialities).records
  end
end
