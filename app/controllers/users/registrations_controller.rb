class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  after_action :notify, :first_signup_fill_infor


  def plan
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  end

  def first_signup_fill_infor
  end

  private

  def notify
    @admin = User.find(125)
    
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:work_position, :description, :experience, :website, :specialities, :education, :experience_level, :language])
  end

  # Update resource without password.
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # The path used after signup.
  def after_sign_up_path_for(resource)
    '/join/plan'
  end

  # The path used after sign update.
  def after_update_path_for(resource)
    resource.work_position == nil ? '/join/finish' : root_path
  end
  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
