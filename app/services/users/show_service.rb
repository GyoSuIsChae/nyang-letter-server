# frozen_string_literal: true

class Users::ShowService < ServiceBase
  string :uid, :token_user_uid

  def execute
    if uid != token_user_uid
      raise UnauthorizedError.new
    end
    User.find_by(uid: uid)
  end
end
