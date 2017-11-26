class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do
    render json: {}, status: :bad_request
  end
end
