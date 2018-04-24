class HomeController < ApplicationController

  
  def index
    if user_signed_in? && current_user.is_recruiter?
      @jobs = current_user.jobs.order_by('start_at', 'DESC').page(params[:page])
      render :dashboard
    end
  end

  def message_thread
    
  end

  def user_profile
    @user = current_user
  end

  def profile
    @user = User.friendly.find(params[:id])
    render :user_profile
  end

  def setting
  	
  end

  def appropriate_jobs
    @appropricate_jobs = Job.search(current_user.work_position + " " + current_user.description + " " + current_user.experience).records
  end
  
end
