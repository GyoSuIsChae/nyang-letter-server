# frozen_string_literal: true

module Transactionable
  extend ActiveSupport::Concern

  included do
    set_callback :execute, :around, -> (_interaction, block) {
      ActiveRecord::Base.transaction(&block)
    }
  end
end
