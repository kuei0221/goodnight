module Api
  module V1
    class FollowingsController < ApiController

      def index
        @following_users = current_user.following_users
      end

      def create
        @follow = Follow.new(follower: current_user, following_id: params[:following_user_id])
        if @follow.save
          render json: { message: 'Follow Success' }, status: :created
        else
          render json: { error: @follow.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @follow = Follow.find_by!(follower: current_user, following_id: params[:id])
        if @follow.destroy
          render json: { message: 'Unfollow Success' }, status: :ok
        else
          render json: { error: @follow.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def follow_params
        params.permit(:following_user_id)
      end
    end
  end
end
