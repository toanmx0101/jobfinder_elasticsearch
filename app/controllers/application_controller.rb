class ApplicationController < ActionController::Base
	respond_to :html, :json
  protect_from_forgery with: :exception
end
