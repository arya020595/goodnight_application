class SleepRecordsController < ApplicationController
  def create
    sleep_record = SleepRecord.new(sleep_record_params)
    if sleep_record.save
      render json: sleep_record, status: :created
    else
      render json: { errors: sleep_record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    sleep_records = SleepRecord.where(user_id: params[:user_id])
                               .recent_first
                               .page(params[:page])
                               .per(params[:per] || 10) # Use dynamic `per`, default to 10

    render json: {
      records: sleep_records,
      meta: {
        current_page: sleep_records.current_page,
        total_pages: sleep_records.total_pages,
        total_count: sleep_records.total_count
      }
    }
  end

  private

  def sleep_record_params
    params.require(:sleep_record).permit(:user_id, :clock_in, :clock_out)
  end
end
