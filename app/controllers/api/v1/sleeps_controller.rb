module Api
  module V1
    class SleepsController < ApiController
      before_action :set_sleep, only: :update

      def index
        @sleeps = Sleep.where(user: current_user)
                       .order(start_at: :desc)
                       .page(params[:page])
        render json: @sleeps, status: :ok
      end

      def create
        @sleep = Sleep.new(user: current_user, start_at: Time.now)
        if @sleep.save
          render json: @sleep, status: :created
        else
          render json: { error: @sleep.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        @sleep.end_at = Time.now
        if @sleep.save
          render json: @sleep, status: :ok
        else
          render json: { error: @sleep.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_sleep
        @sleep = Sleep.where(user: current_user).find(params[:id])
      end
    end
  end
end
