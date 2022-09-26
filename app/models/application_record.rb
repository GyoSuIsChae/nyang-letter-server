# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.generate_unique_secure_token(length = nil)
    # uuid v4
    SecureRandom.uuid
  end

  scope :paginate, -> (params) {
    if params.respond_to?(:permit)
      permitted = params.permit(:page, :size)
    else
      permitted = params
    end
    page = permitted.fetch(:page, 1).to_i
    size = permitted.fetch(:size, 100).to_i

    page = [1, page].max
    size = [100, size].min

    page(page).per(size)
  }
end
