module Api
  module V1
    class UsersController < ApplicationController

        skip_before_action :authenticate_request, only: [:login, :create]
        before_action :authenticate_user,  only: [:current, :update]
        before_action :authorize_as_admin, only: [ :index,:destroy]
        before_action :authorize,          only: [:update]
        # Method to create a new user using the safe params we setup.
        def create
            user = User.new(user_params)
            if user.save
                response = { message: 'User created successfully'}
                render json: response, status: :created 
            else
                render json: @user.errors, status: :bad
            end
        end
      
      # Method to update a specific user. User will need to be authorized.
      def update
        user = User.find(params[:id])
        if user.update(user_params)
          render json: { status: 200, msg: 'User details have been updated.' }
        end
      end
      
      # Method to delete a user, this method is only for admin accounts.
      def destroy
        user = User.find(params[:id])
        if user.destroy
          render json: { status: 200, msg: 'User has been deleted.' }
        end
      end

      # Should work if the current_user is authenticated.
      def index
        @users = User.all
        render json: @users
      end
      
      # Call this method to check if the user is logged-in.
      # If the user is logged-in we will return the user's information.
      def current
        current_user.update!(last_login: Time.now)
        render json: current_user
      end
      
      def login
        authenticate params[:email], params[:password]
      end

      private
      
      def authenticate(email, password)
        command = AuthenticateUser.call(email, password)

        if command.success?
          render json: {
            access_token: command.result,
            message: 'Login Successful'
          }
        else
          render json: { error: command.errors }, status: :unauthorized
        end
      end
      # Setting up strict parameters for when we add account creation.
      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end
      
      # Adding a method to check if current_user can update itself. 
      # This uses our UserModel method.
      def authorize
            render json: { error: 'You are not authorized to modify this data'} , status: 401 unless current_user && current_user.can_modify_user?(params[:id])
      end
    end
  end
end