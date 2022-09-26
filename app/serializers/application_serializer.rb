# frozen_string_literal: true

class ApplicationSerializer < ActiveModel::Serializer
  include AmsLazyRelationships::Core
  # uid가 있는 경우 자동으로 :id 로 변경함
  attribute :uid, key: :id, if: -> () { self.respond_to?(:uid) || object.respond_to?(:uid) }
end
