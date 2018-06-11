class AppliesController < ApplicationController
  before_action :set_apply, only: [:destroy]
  before_action :authenticate_user!
  after_action :notify, only: [:create], if: -> { user_signed_in? && (current_user.id != @job.user_id) && @apply.id.present? }

  def index
    @applies = current_user.applies
  end

  def create
    @job = Job.find(params[:job_id])
    @apply = current_user.applies.build(job_id: @job.id)
    respond_to do |format|
      if !current_user.have_recruitment?(@job) && @apply.save
        format.html { redirect_to @job, notice: "You have just applied #{@job.title}. Please check email."}
        format.json { render :show, status: :created, location: @apply }
      else
        format.html { redirect_to @job, alert: "Error when apply this job" }
        format.json { render json: @apply.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @apply.destroy
    respond_to do |format|
      format.html { redirect_to applies_url, notice: 'Apply was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def apply_params
      params.require(:apply).permit(:job_id)
    end

    def notify
      recruiter_notification = Notification.create(recipient_id: @job.user_id,
                          actor_id: current_user.id,
                          action: "<strong>#{current_user.username}</strong> has just applied your job: <strong>#{ @job.title.truncate(40)}</strong>.")
      applyer_notification = Notification.create(recipient_id: @apply.applyer_id,
                          actor_id: current_user.id,
                          action: "<strong>You</strong> have just applied <strong>#{ @job.title.truncate(40)}</strong>.")
      recruiter_notification.update_attribute(:notifiable, @apply)
      applyer_notification.update_attribute(:notifiable, @job)
    end
end
