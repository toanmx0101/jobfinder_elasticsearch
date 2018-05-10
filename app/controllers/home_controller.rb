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
    @days = current_user.meetings.where(start_at: DateTime.now.beginning_of_week..DateTime.now.end_of_week).group_by{|meeting| meeting.start_at.strftime("%Y-%m-%d")}
    @days = @days.sort_by{|day, _interviews| day }
    # if params[:ref] == 'week'
    # end
  end

  def candidates

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
