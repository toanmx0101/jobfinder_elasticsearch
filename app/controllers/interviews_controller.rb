class InterviewsController < ApplicationController
  before_action :set_interview, only: [ :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def create
    start_at = Time.zone.parse(interview_params[:day] + ' ' +  interview_params[:hour] + ':' + interview_params[:minute])
    @interview = current_user.meetings.build(title: interview_params[:title],
                                             description: interview_params[:description],
                                             duration: interview_params[:duration],
                                             start_at: start_at,
                                             interviewer_id: interview_params[:interviewer_id],
                                             job_id: interview_params[:job_id]
                                             )
    respond_to do |format|
      if @interview.save
        format.html { redirect_to interviews_path, notice: 'Interview was successfully created.' }
        format.json { render :show, status: :created, location: @interview }
      else
        format.html { render :new }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @interview.update(interview_params)
        format.html { redirect_to interviews_path, notice: 'Interview was successfully updated.' }
        format.json { render :show, status: :ok, location: @interview }
      else
        format.html { render :edit }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @interview.destroy
    respond_to do |format|
      format.html { redirect_to interviews_url, notice: 'Interview was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_interview
      @interview = Interview.find(params[:id])
    end

    def interview_params
      params.require(:interview).permit(:title, :description, :interviewer_id, :job_id, :duration, :day, :hour, :minute)
    end
end
