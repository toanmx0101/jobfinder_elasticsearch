class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :destroy, :update, :edit]
  after_action :notify, only: [:show], if: -> { user_signed_in? && current_user.id != @job.user_id }

  def index; end

  def dashboard; end

  def search
    per_page = 10
    s = escape_characters_in_string(params[:q])
    location = params[:location].present? ? params[:location] : nil
    job_type = params[:job_type].present? ? params[:job_type] : nil
    salary = params[:salary].present? ? params[:salary] : ""
    tags = []
    # search params (page, limit, location, job_type, salary, tags = [], keyword_match = nil)
    results = Job.search_el(params[:page], Job::PER_PAGE ,
                          location,
                          job_type,
                          salary,
                          tags,
                          s)
    res_jobs = results[:body].is_a?(Job) ? [results[:body]] : results[:body]
    @jobs = Kaminari.paginate_array(res_jobs,
                                        total_count: results[:total],
                                        offset: results[:from],
                                        limit: per_page
                                        ).page(params[:page]).per(per_page)
    @jobs_score = results[:jobs_score]
    @common_locations = results[:common_locations]
    @common_job_types = results[:common_job_types]
    @total_results = results[:total]
    respond_to do |format|
      format.html
      format.json { render json: { jobs: @jobs.as_json,
                                   jobs_score: @jobs_score.as_json,
                                   common_locations: @common_locations,
                                   common_job_types: @common_job_types,
                                   total_results: @total_results } }
    end
  end

  def show
    @random_jobs = Job.order("RANDOM()").limit(4)
    @more_jobs = @job.user.jobs.sample(5)
    if user_signed_in?
      @applied = Apply.exists?(applyer_id: current_user.id, job_id: @job.id)
    end
    @user_also_viewed = User.get_similar_jobs_by_history([@job.id])[:body]
    if @user_also_viewed.empty?
      @user_also_viewed = Job.find(Job.simple_match_jobs_query(@job.title).first(5))
    end
  end

  def newy
    @job = Job.new
  end

  def edit; end

  def create
    @job = current_user.jobs.build(job_params)

    respond_to do |format|
      if @job.save
        format.html { redirect_to root_path, notice: 'Job was successfully created.' }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def escape_characters_in_string(string)
      pattern = /(\'|\"|\.|\*|\/|\-|\+|\]|\[|\)|\(|\\)/
      string.gsub(pattern){|match|"\\"  + match}
    end

    def set_job
      @job = Job.includes(:user).find(params[:id].to_i)

    end

    def job_params
      params.require(:job).permit(:title, :description, :about_candidate, :job_type, :location, :salary)
    end

    def notify
      notification = Notification.create(recipient_id: @job.user_id,
                          actor_id: current_user.id,
                          action: "<strong>#{current_user.username}</strong> viewed your job: <strong>#{ @job.title.truncate(40)}</strong>.")
      notification.update_attribute(:notifiable, @job)
    end
end
