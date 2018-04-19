class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :destroy, :update, :edit]

  def index; end

  def dashboard; end

  def search
    s = escape_characters_in_string(params[:q])
    @jobs = Job.search(s).records
    render action: "index"
  end
  
  def show
    @random_jobs = Job.order("RANDOM()").limit(4)
  end

  def new 
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
    # Use callbacks to share common setup or constraints between actions.
    def escape_characters_in_string(string)
      pattern = /(\'|\"|\.|\*|\/|\-|\+|\]|\[|\)|\(|\\)/
      string.gsub(pattern){|match|"\\"  + match}
    end

    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:title, :description, :about_candidate, :job_type, :pay_rate)
    end
end
