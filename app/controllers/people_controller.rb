class PeopleController < ApplicationController
	def new
		@person = Person.new
	end

	def create
		@person = Person.new
		@person.name = params[:person][:name]
		@person.description = params[:person][:description]
		@person.website = params[:person][:website]
		@person.email = params[:person][:email]
		@person.twitter = params[:person][:twitter]

		if @person.save
			redirect_to person_path(@person)
		else
			flash[:error] = @person.errors.first
			redirect_back fallback_location: root_path
		end
	end

	def edit
		@person = Person.find(params[:id])
	end

	def update
		unless current_user.is_admin?
			flash[:error] = "Operation not permitted"
			redirect_back fallback_location: root_path
		end

		@person = Person.find(params[:id])
		@person.name = params[:person][:name]
		@person.description = params[:person][:description]
		@person.website = params[:person][:website]
		@person.email = params[:person][:email]
		@person.twitter = params[:person][:twitter]

		if @person.save
			redirect_to person_path(@person)
		else
			flash[:error] = @person.errors.first
			redirect_back fallback_location: root_path
		end
	end

	def show
		@person = Person.find(params[:id])
	end
end