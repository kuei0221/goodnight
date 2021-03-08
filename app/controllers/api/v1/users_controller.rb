module Api
  module V1
    class UsersController < ApiController
      def show
        @user = User.find(params[:id])
        render json: @user, status: :ok
      end
    end
  end
end
