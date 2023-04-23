# frozen_string_literal: true

class Cafes::IndexService < ServiceBase
  paginatable

  record :user, class: User, finder: :find_by_uid!
  string :filter_option

  def execute
    @cafes = Cafe.by_user(user)

    if filter_option == "open"
      @cafes.by_open.order(:open_at)
    elsif filter_option == "closed"
      @cafes = @cafes.by_close.order(:open_at)
    else
      @cafes = @cafes.order(:created_at)
    end

    @cafes
  end
end
