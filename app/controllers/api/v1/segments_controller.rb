module Api
  module V1
    class SegmentsController < ::ApplicationController
      def create
        segment = Segment.new(segment_params)

        if segment.save
          render json: {}, status: :created
        else
          render json: segment.errors, status: :unprocessable_entity
        end
      end

      private

      def segment_params
        params.require(:segment).permit!
      end
    end
  end
end
