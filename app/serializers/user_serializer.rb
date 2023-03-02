# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  attributes :login_type, :nickname, :email, :is_complete_tutorial, :status, :created_at

  def status
    object.status.upcase
  end

  def login_type
    object.login_type.upcase
  end
end
