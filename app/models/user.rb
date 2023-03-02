# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_token :uid
  acts_as_paranoid

  enum :login_type, { "kakao": "10", "google": "20", "naver": "30" }
  enum :status, { "active": "10", "inactive": "20", "leave": "99" }

  scope :by_social_id, -> (social_id) { where(social_id: social_id) }
  scope :by_login_type, -> (login_type) { where(login_type: login_type) }
  scope :by_nickname, -> (nickname) { where(nickname: nickname) }
  scope :by_uid, -> (uid) { where(uid: uid) }
end
