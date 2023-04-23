# frozen_string_literal: true

class Cafe < ApplicationRecord
  has_secure_token :uid
  acts_as_paranoid

  belongs_to :user

  enum :theme, { "new_year": "10", "birthday": "20", "christmas": "30" }
  enum :status, { "before_opening": "10", "opening": "20", "deleted": "99" }

  scope :by_user, -> (user) { where(user: user) }
  scope :by_open, -> (open_at = nil) { open_at ||= DateTime.current; where("open_at >= ?", open_at) }
  scope :by_close, -> (open_at = nil) { open_at ||= DateTime.current; where("open_at <= ?", open_at) }
end
