module Api
  module V1
    class FollowingSleepsController < ApiController
      before_action :set_order_direction, only: :index

      def index
        @following_sleeps = Sleep.includes(:user)
                                 .where(user: current_user.following_users)
                                 .where('start_at > ?', Time.now.prev_week)
                                 .order(duration: params[:order])
                                 .page(params[:page])
      end
    end
  end
end
