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
    sleep_records = SleepRecord.where(user_id: params[:user_id]).order(created_at: :desc)
    render json: sleep_records
  end

  private

  def sleep_record_params
    params.require(:sleep_record).permit(:user_id, :clock_in, :clock_out)
  end
end
