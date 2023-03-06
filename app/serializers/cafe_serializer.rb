# frozen_string_literal: true

class CafeSerializer < ApplicationSerializer
  belongs_to :user
  attributes :name, :open_at, :theme, :unread_letter_count, :status, :created_at

  def status
    object.status.upcase
  end

  def theme
    object.theme.upcase
  end
end
