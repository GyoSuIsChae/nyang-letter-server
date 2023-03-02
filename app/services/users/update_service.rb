# frozen_string_literal: true

class Users::UpdateService < ServiceBase
  record :user, finder: :find_by_uid!, class: User
  string :uid
  string :nickname, :is_complete_tutorial, default: nil

  validates :is_complete_tutorial, inclusion: %w[Y N]

  def execute
    if uid != user.uid
      raise UnauthorizedError.new
    end

    @user = User.by_uid(uid)

    if nickname != nil
      # 닉네임 중복 체크
      if User.by_nickname(nickname).present?
        raise Users::IsAlreadyExistNicknameError.new
      end

      @user.update(nickname: nickname)
    end

    if is_complete_tutorial != nil
      @user.update(is_complete_tutorial: is_complete_tutorial)
    end

    @user.last
  end
end
