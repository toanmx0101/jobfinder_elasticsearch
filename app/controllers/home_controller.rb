class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:message_thread, :profile, :setting, :appropriate_jobs, :appliers, :rc_messages]

  def index
    if user_signed_in? && current_user.is_recruiter?
      if params[:q].present? 
        @jobs = current_user.jobs.where("title LIKE '%#{params[:q]}%' OR id=#{params[:q].to_i}")
      else
        @jobs = current_user.jobs
      end
      @jobs = @jobs.order_by('start_at', 'DESC').page(params[:page])
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
      @applies = Apply.includes(:applyer).includes(:job).where(job_id: current_user.jobs).page(params[:page])
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
    if params[:ref].present? && params[:ref] == 'month'
      range = DateTime.now.beginning_of_month..DateTime.now.end_of_month
    else
      range = DateTime.now.beginning_of_week..DateTime.now.end_of_week
    end
    @days = current_user.meetings.where(start_at: range).group_by{|meeting| meeting.start_at.strftime("%Y-%m-%d")}
    @days = @days.sort_by{|day, _interviews| day }
  end

  def candidates
    @candidates = []
    if params[:job_id].present?
      @job = Job.find_by(id: params[:job_id])
      results = User.find_candidates_by_job(params[:page], 5, @job)

      @candidates = results[:body].is_a?(User) ? [results[:body]] : results[:body]
      @total_results = results[:total]
      @user_score = results[:user_score]
    elsif params[:username].present? || params[:skills].present? || params[:work_position].present?
      username = params[:username].present? ? params[:username] : ""
      skills = params[:skills].present? ? params[:skills] : ""
      work_position = params[:work_position].present? ? params[:work_position] : ""

      results = User.find_candidates_by_params(params[:page], 5, username, work_position, skills)

      @candidates = results[:body].is_a?(User) ? [results[:body]] : results[:body]
      @total_results = results[:total]
      @user_score = results[:user_score]
    end
    respond_to do |format|
      format.html
      format.json { render json: { candidates: @candidates.as_json( only: [:id, :username, :work_position, :description, :experience, :avatar_url, :tags]), user_score: @user_score, total_results: @total_results } }
    end
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

  def rc_messages
    @conversations = current_user.conversations.includes(:receiver).order(updated_at: :desc)
    if params[:id].blank?
      @recent_conversation = @conversations.first
      redirect_to "/rc_messages/" + @recent_conversation.id.to_s
    else
      @recent_conversation = Conversation.includes(:receiver).find(params[:id])
    end
    @sended_messages ||= @recent_conversation.messages.order(created_at: :desc)
    @received_messages ||= Conversation.find_by(sender_id: @recent_conversation.receiver_id, receiver_id: current_user.id).messages.includes(:user).order(created_at: :desc)
    @list_messages ||= (@sended_messages + @received_messages).sort_by{|mes| mes.created_at }
  end

  def new_interviews
    @interview = Interview.new
  end
end
