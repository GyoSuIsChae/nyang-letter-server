# frozen_string_literal: true

module Authenticatable
  extend ActiveSupport::Concern

  attr_reader :current_user

  def auth_payload
    @payload
  end

  def authenticate_user
    # decode => camelcase
    @current_user ||= if access_token
      algorithms = [Rails.configuration.x.auth.signing_algorithm]
      key = Rails.configuration.x.auth.secret_key
      decoded = JWT.decode(access_token, key, true, { algorithms: algorithms })
      @payload = payload = CaseTransform.underscore(decoded.first || {})

      if payload.fetch("type", nil) == "ACCESS_TOKEN"
        user_uid = payload.fetch("user_id", nil)
        @user = User.find_by(uid: user_uid)
        status
      else
        nil
      end
    else
      nil
    end
  end

  def status
    case @user.status.to_sym
    when :complete, :block
      @user
    else
      nil
    end
  end

  def authenticate_all_user!
    authenticate_all_user
    if current_user.nil?
      Rails.logger.fatal "Invalid Access Token"
      render error: { status: :unauthorized, code: I18n.t("base_errors.invalid_access_token.code"),
                      message: I18n.t("base_errors.invalid_access_token.message"), context: "Invalid Access Token" }
    end
  rescue StandardError
    Rails.logger.info "Access Token Parse Error"
    render error: { status: :unauthorized, code: I18n.t("base_errors.not_parse_access_token.code"),
                    message: I18n.t("base_errors.not_parse_access_token.message"), context: "Access Token Parse Error" }
  end

  def authenticate_user!
    authenticate_user
    if current_user.nil?
      Rails.logger.fatal "Invalid Access Token"
      render error: { status: :unauthorized, code: I18n.t("base_errors.invalid_access_token.code"),
                      message: I18n.t("base_errors.invalid_access_token.message"), context: "Invalid Access Token" }
    else
      if current_user.status == "inactive"
        Rails.logger.fatal "User Is inactivated"
        raise Users::InactiveError.new
      end
    end
  rescue StandardError
    Rails.logger.info "Access Token Parse Error"
    render error: { status: :unauthorized, code: I18n.t("base_errors.not_parse_access_token.code"),
                    message: I18n.t("base_errors.not_parse_access_token.message"), context: "Access Token Parse Error" }
  end

  def access_token
    @access_token ||= begin
                        header = request.headers.fetch("Authorization", "")
                        header.split(" ").last
                      end
  end
end
