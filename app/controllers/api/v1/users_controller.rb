module Api
  module V1
    class UsersController < ::ApplicationController
      def index
        segmentation = Segmentation.new(params[:segment])
        render json: User.where(segmentation.conditions)
      end

      def create
        user = User.new(user_params)

        if user.save
          render json: {}, status: :created
        else
          render json: user.errors, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :birth_date, :is_active,
                                     :admission_date, :sex, :last_sign_in_at, tags_attributes: [ :name ])
      end
    end
  end
end
