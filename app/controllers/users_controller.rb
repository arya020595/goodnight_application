# app/controllers/sleep_records_controller.rb
class SleepRecordsController < ApplicationController
  def create
    sleep_record_service = SleepRecordService.new
    result = sleep_record_service.create_sleep_record(sleep_record_params)

    if result[:success]
      render json: ResponseService.success(result[:sleep_record])
    else
      render json: ResponseService.error(422, result[:errors].join(', '))
    end
  end

  def index
    sleep_record_service = SleepRecordService.new
    result = sleep_record_service.fetch_sleep_records(params[:user_id], params[:page], params[:per] || 10)

    if result[:success]
      render json: ResponseService.success(result[:records], result[:meta])
    else
      render json: ResponseService.error(422, 'Unable to fetch sleep records')
    end
  end

  private

  def sleep_record_params
    params.require(:sleep_record).permit(:user_id, :clock_in, :clock_out)
  end
end
