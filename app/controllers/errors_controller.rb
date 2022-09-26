# frozen_string_literal: true

class ErrorsController < ApplicationController
  def default
    render error: { status: 500, code: I18n.t("base_errors.system_error.code"),
                    message: I18n.t("base_errors.system_error.message"), context: "" }
  end

  def bad_params
    render error: { status: 400, code: I18n.t("base_errors.invalid.code"),
                    message: I18n.t("base_errors.invalid.message"), context: "" }
  end

  def missing
    render error: { status: 404, code: I18n.t("base_errors.not_found.code"),
                    message: I18n.t("base_errors.not_found.message"), context: "" }
  end
end
