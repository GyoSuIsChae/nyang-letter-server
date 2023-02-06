# frozen_string_literal: true

class UsersController < ApplicationController
=begin
  소셜 로그인 API
  request URL: /api/v1/users/sign-in
  request Params: login_type, access_code
=end
  def sign_in
    result = Users::SignInService.run!(sign_in_params)
    render api: result, status: :ok
  end

  private
    def sign_in_params
      api_params.permit(:login_type, :access_code)
    end
end
