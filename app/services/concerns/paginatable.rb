# frozen_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  included do
    integer :page, default: 1
    integer :size, default: 30
  end

  def paginated
    result.page(page).per(size)
  end
end
