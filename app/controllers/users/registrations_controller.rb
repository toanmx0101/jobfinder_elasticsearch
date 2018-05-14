class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  # after_action :notify, only: [:first_signup_fill_infor]

  def plan
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  end

  def first_signup_fill_infor; end

  private

  def notify
    @admin = User.find(125)
    tags = Job.generate_tags(current_user.work_position)
    current_user.update_attribute(:tags, tags)
    location = current_user.location.present? ? current_user.location : ""
    experience = current_user.experience.present? ? current_user.experience : ""
    job_type = ""
    salary = ""
    @interested_jobs = Job.search_el(1, Job::PER_PAGE , 
                          location,
                          job_type,
                          salary,
                          tags, 
                          current_user.work_position + experience )[:body]
    notification = Notification.create(recipient_id: current_user,
                          actor_id: @admin.id,
                          action: "We found jobs that you maybe interested in.")
    
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:work_position, :description, :experience, :website, :specialities, :education, :experience_level, :language])
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_sign_up_path_for(resource)
    '/join/plan'
  end

  def after_update_path_for(resource)
    resource.work_position == nil ? '/join/finish' : root_path
  end

  def after_inactive_sign_up_path_for(resource)
    '/join/plan' # Or :prefix_to_your_route
  end
end
