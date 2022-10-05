# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit::Authorization
  include ParameterAcceptable

  rescue_from StandardError, with: :exception_handler
  rescue_from ActiveRecord::RecordNotFound do |exception|
    Rails.logger.info(exception)
    render error: { status: 404, code: I18n.t("base_errors.record_not_found.code"),
                    message: I18n.t("base_errors.record_not_found.message"), context: exception.class.to_s }
  end
  rescue_from ActiveRecord::RecordInvalid, ActiveModel::ValidationError, ActionController::ParameterMissing do |exception|
    Rails.logger.info(exception)
    render error: { status: 400, code: I18n.t("base_errors.invalid.code"),
                    message: I18n.t("base_errors.invalid.message"), context: exception.class.to_s }
  end
  rescue_from ActiveInteraction::Error do |exception|
    Rails.logger.info(exception)
    render error: { status: 400, code: I18n.t("base_errors.active_interaction_error.code"),
                    message: exception.interaction.errors.full_messages.to_sentence, context: exception.class.to_s }
  end
  rescue_from Pundit::NotAuthorizedError, ForbiddenError do |exception|
    Rails.logger.info(exception)
    render error: { status: 403, code: I18n.t("base_errors.forbidden.code"),
                    message: I18n.t("base_errors.forbidden.message"), context: exception.class.to_s }
  end
  rescue_from UnauthorizedError do |exception|
    Rails.logger.info(exception)
    render error: { status: 401, code: I18n.t("base_errors.unauthorized.code"),
                    message: I18n.t("base_errors.unauthorized.message"), context: exception.class.to_s }
  end
  rescue_from BaseError do |exception|
    Rails.logger.info(exception)
    render error: { status: I18n.t("base_errors.#{exception.to_s.underscore}.code").to_s.slice(0..2), code: I18n.t("base_errors.#{exception.to_s.underscore}.code"),
                    message: I18n.t("base_errors.#{exception.to_s.underscore}.message"), context: exception.class.to_s }
  end
  def api_params
    case ActiveModelSerializers.config.key_transform
    when :camel_lower
      ActionController::Parameters.new(CaseTransform.underscore(params.to_unsafe_h.reject { |k, v| v.nil? }))
    else
      params
    end
  end

  def exception_handler(error)
    Rails.logger.fatal(error.to_s)
    if error.backtrace_locations
      Rails.logger.fatal(error.backtrace_locations.join("\n"))
    end

    render(error: { status: 500, code: I18n.t("base_errors.system_error.code"),
                    message: I18n.t("base_errors.system_error.message"), context: error.to_s })
  end
end
