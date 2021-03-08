module Api
  module V1
    class ApiController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

      private

      def record_not_found(exception)
        render json: { error: exception.to_s }, status: :not_found
      end

      def current_user
        @current_user ||= User.find(params[:user_id])
      end

      def set_order_direction
        params[:order] = 'desc' unless %w[asc desc].include?(params[:order])
      end
    end
  end
end
