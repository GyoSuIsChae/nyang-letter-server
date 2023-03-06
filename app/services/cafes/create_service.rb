# frozen_string_literal: true

class Cafes::CreateService < ServiceBase
  transactionable

  record :user, class: User, finder: :find_by_uid!
  string :name, :theme, :user_uid
  date_time :open_at

  validates :theme, inclusion: { in: %w[NEW_YEAR BIRTHDAY CHRISTMAS] }

  def execute
    if user.uid != user_uid
      raise ForbiddenError.new
    end

    check_name_length!
    check_open_at!

    Cafe.create!(user: user,
                 name: name,
                 open_at: open_at,
                 theme: theme.downcase,
                 status: :before_opening)
  end

  private
    def check_name_length!
      if name.length > 50
        raise Cafes::NameLimitError.new
      end
    end

    def check_open_at!
      if open_at < DateTime.now
        raise Cafes::OpenAtIsCanNotEarlierThanNowError.new
      end
    end
end
