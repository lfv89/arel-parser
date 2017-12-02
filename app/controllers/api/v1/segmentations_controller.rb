module Api
  module V1
    class SegmentationsController < ::ApplicationController
      def show
        render json: Segmentation.new(params[:id]).load
      end
    end
  end
end
