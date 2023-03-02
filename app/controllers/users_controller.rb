# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
=begin
  소셜 로그인 API
  request URI: /api/v1/users/sign-in
  request Params: login_type, access_code
=end
  def sign_in
    result = Users::SignInService.run!(sign_in_params)
    render api: result, status: :ok
  end

=begin
  유저 정보 조회 API
=end
  def show
    result = Users::ShowService.run!(show_params)
    render api: result, status: :ok
  end

  private
    def sign_in_params
      api_params.permit(:login_type, :access_code)
    end

    def show_params
      api_params.permit(:uid).merge(token_user_uid: current_user.uid)
    end
end
