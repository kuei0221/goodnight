module Api
  module V1
    class SleepsController < ApiController
      before_action :set_sleep, only: :update
      before_action :check_sleep_ongoing, only: :update
      before_action :set_order_direction, only: :index
      before_action :check_user_sleeping, only: :create

      def index
        @sleeps = Sleep.where(user: current_user)
                       .order(start_at: params[:order])
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

      def check_user_sleeping
        return unless current_user.sleeping?

        render json: { error: 'End the current sleep to start new one' }, status: :unprocessable_entity
      end

      def check_sleep_ongoing
        return if @sleep.ongoing?

        render json: { error: 'Sleep is already ended, do not overwrite it' }, status: :unprocessable_entity
      end
    end
  end
end
