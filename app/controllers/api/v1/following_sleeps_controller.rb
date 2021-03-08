module Api
  module V1
    class FollowingSleepsController < ApiController
      def index
        @following_sleeps = Sleep.includes(:user)
                                 .where(user: current_user.following_users)
                                 .where('start_at > ?', Time.now.prev_week)
                                 .order(duration: :desc)
                                 .page(params[:page])
      end
    end
  end
end
