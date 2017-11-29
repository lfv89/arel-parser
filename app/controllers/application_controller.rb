class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do
    render json: {}, status: :bad_request
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: {}, status: :not_found
  end
end
