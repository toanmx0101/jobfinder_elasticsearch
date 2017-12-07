class HomeController < ApplicationController
	def index
		if user_signed_in?
			 render :dashboard
		end
	end
end
