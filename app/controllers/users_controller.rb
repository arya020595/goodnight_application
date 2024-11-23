# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def follow
    user_service = UserService.new
    result = user_service.follow(params[:id], follow_params[:followed_id])

    if result[:success]
      render json: ResponseService.success({ id: params[:id], name: result[:user].name,
                                             message: result[:message] })
    else
      render json: ResponseService.error(422, result[:errors].join(', '))
    end
  end

  def unfollow
    user_service = UserService.new
    result = user_service.unfollow(params[:id], follow_params[:followed_id])

    if result[:success]
      render json: ResponseService.success({ id: params[:id], name: result[:user].name,
                                             message: result[:message] })
    else
      render json: ResponseService.error(422, result[:errors])
    end
  end

  def followings_sleep_records
    user_service = UserService.new
    result = user_service.followings_sleep_records(params[:id], params[:page], params[:per] || 10)

    if result[:success]
      render json: ResponseService.success(result[:data], result[:meta])
    else
      render json: ResponseService.error(404, 'No sleep records found for followings')
    end
  end

  def average_sleep_duration
    user_service = UserService.new
    result = user_service.average_sleep_duration(params[:id])

    if result[:success]
      render json: ResponseService.success(result[:data])
    else
      render json: ResponseService.error(404, result[:data][:message])
    end
  end

  private

  def follow_params
    params.require(:follow).permit(:followed_id)
  end
end
