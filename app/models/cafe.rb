# frozen_string_literal: true

class Cafe < ApplicationRecord
  has_secure_token :uid
  acts_as_paranoid

  belongs_to :user

  enum :theme, { "new_year": "10", "birthday": "20", "christmas": "30" }
  enum :status, { "before_opening": "10", "opening": "20", "deleted": "99" }
end
