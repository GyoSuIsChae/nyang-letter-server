# frozen_string_literal: true

class HashSerializer < ActiveModel::Serializer
  attributes :hash

  # 아래 메서드가 없으면 ActiveModel::Serializer가 자동으로 to_s 해서 내보냄.
  def hash
    object.hash
  end

  def serializable_hash(instance_options, options, context)
    hash
  end
end

class HashResource < ActiveModelSerializers::Model
  attributes :hash
end

ActiveSupport.on_load(:action_controller) do
  ActiveModelSerializers.config.key_transform = :camel_lower
  ActiveModelSerializers.config.default_api_version = "1.0"

  ActionController::Renderers.add :api do |json, options|
    options[:type] = :api
    options[:adapter] = GoogleJsonStyleGuideAdapter
    options.fetch(:serialization_context) do
      options[:serialization_context] = ActiveModelSerializers::SerializationContext.new(request)
    end

    if json.nil?
      json = { status: 404, code: I18n.t("base_errors.record_not_found.code"),
               message: I18n.t("base_errors.record_not_found.message") }
      options[:type] = :error
      options[:status] = 404
    end

    if json.instance_of?(Hash)
      json = HashResource.new(hash: json)
      options[:serializer] = HashSerializer
    end

    response_body = get_serializer(json, options).to_json(options) unless json.is_a?(String)
    self.content_type = Mime[:json]
    self.response_body = response_body
    self.status = options.fetch(:status, 200)
    response_body
  end

  ActionController::Renderers.add :error do |json, options|
    raise "error[:status] is not specified" unless json[:status]
    options[:type] = :error
    options[:adapter] = GoogleJsonStyleGuideAdapter
    options.fetch(:serialization_context) do
      options[:serialization_context] = ActiveModelSerializers::SerializationContext.new(request)
    end

    resource = HashResource.new(hash: json)
    options[:serializer] = HashSerializer

    response_body = get_serializer(resource, options).to_json(options) unless json.is_a?(String)
    self.content_type = Mime[:json]
    self.response_body = response_body
    self.status = options.fetch(:status, json[:status])
    response_body
  end
end
