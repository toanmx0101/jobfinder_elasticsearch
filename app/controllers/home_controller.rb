class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:message_thread, :profile, :setting, :appropriate_jobs, :appliers]

  def index
    if user_signed_in? && current_user.is_recruiter?
      @jobs = current_user.jobs.order_by('start_at', 'DESC').page(params[:page])
      render :dashboard
    end
  end

  def user_profile
    @user = current_user
  end

  def profile
    @user = User.friendly.find(params[:id])
    render :user_profile
  end

  def appliers
    if current_user.is_recruiter?
      @applies = Apply.includes(:applyer).includes(:job).where(job_id: current_user.jobs)
    else 
      redirect_to root_path
    end
  end

  def appropriate_jobs
    tags = Job.generate_tags(current_user.work_position)
    current_user.update_attribute(:tags, tags)
    location = current_user.location.present? ? current_user.location : ""
    experience = current_user.experience.present? ? current_user.experience : ""
    job_type = ""
    salary = ""
    @appropricate_jobs = Job.search_el(1, Job::PER_PAGE , 
                          location,
                          job_type,
                          salary,
                          tags, 
                          current_user.work_position + experience )[:body]
  end

  def setting;  end

  def interviews; end

  def candidates; end

  def rc_messages; end

  def message_thread; end
end
