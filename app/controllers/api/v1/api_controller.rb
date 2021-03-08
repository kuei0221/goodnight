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
    end
  end
end
