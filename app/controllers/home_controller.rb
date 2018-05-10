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

  def interviews
    if params[:ref] == 'week'
      range = DateTime.now.beginning_of_week..DateTime.now.end_of_week
    elsif params[:ref] == 'month'
      range = DateTime.now.beginning_of_month..DateTime.now.end_of_month
    end
    
    @days = current_user.meetings.where(start_at: range).group_by{|meeting| meeting.start_at.strftime("%Y-%m-%d")}
    @days = @days.sort_by{|day, _interviews| day }
  end

  def candidates
    username = params[:username].present? ? params[:username] : ""
    skills = params[:skills].present? ? params[:skills] : ""
    work_position = params[:work_position].present? ? params[:work_position] : ""
    @users = User.search_el(username, skills, location)
  end

  def simple_search_job
    jobs = current_user.jobs.where("title LIKE '%#{params[:title]}%' OR id=#{params[:title].to_i}")
    if params[:limit].present?
      jobs = jobs.limit(2)
    end
    respond_to do |format|
      format.json { render json: jobs.to_json( only: [:id, :title] ), status: :ok }
    end
  end

  def simple_search_user
    users = User.where("username LIKE '%#{params[:username]}%' OR id=#{params[:username].to_i}").limit(2)
    respond_to do |format|
      format.html
      format.js {}
      format.json { render json: users.to_json( only: [:username, :id, :work_position, :avatar_url] ), status: :ok }
    end
  end

  def rc_messages; end

  def message_thread; end

  def new_interviews
    @interview = Interview.new
  end
end
