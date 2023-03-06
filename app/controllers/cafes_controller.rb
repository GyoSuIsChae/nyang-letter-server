# frozen_string_literal: true

class CafesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
=begin
  카페 만들기
=end
  def create
    result = Cafes::CreateService.run!(create_params)
    render api: result, status: :created
  end

  private
    def create_params
      api_params.permit(:user_uid, :name, :open_at, :theme).merge(user: current_user)
    end
end
