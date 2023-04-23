# frozen_string_literal: true

class CafesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :index]
=begin
  카페 만들기
=end
  def create
    result = Cafes::CreateService.run!(create_params)
    render api: result, status: :created
  end

=begin
   카페 리스트 조회
=end
  def index
    result = Cafes::IndexService.run(index_params)

    if result.valid?
      render api: result.paginated, status: :ok, each_serializer: CafeSerializer
    else
      render error: { status: :bad_request, code: I18n.t("base_errors.active_interaction_error.code"),
                      message: result.error_message, context: result.errors }
    end
  end

  private
    def create_params
      api_params.permit(:user_uid, :name, :open_at, :theme).merge(user: current_user)
    end

    def index_params
      api_params.permit(:page, :size, :filter_option).merge(user: current_user)
    end
end
