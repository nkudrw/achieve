class ApplicationController < ActionController::Base

    before_action :current_notifications, if: :signed_in?

    def current_notifications
      @notifications_count = Notification.where(user_id: current_user.id).where(read: false).count
    end


  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  PERMISSIBLE_ATTRIBUTES = %i(name)
  protected
  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
      devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES)
  end
  rescue_from CanCan::AccessDenied do |exception|
   redirect_to main_app.root_url, :alert => exception.message
 end
 PERMISSIBLE_ATTRIBUTES = %i(name avatar avatar_cache)

  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: PERMISSIBLE_ATTRIBUTES)
      devise_parameter_sanitizer.permit(:account_update, keys: PERMISSIBLE_ATTRIBUTES)
    end


end
