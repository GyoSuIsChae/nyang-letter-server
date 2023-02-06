# frozen_string_literal: true

class Users::CreateJsonWebTokenService < ServiceBase
  record :user, class: User
  string :secret_key, default: -> { Rails.configuration.x.auth.secret_key }
  string :signing_algorithm, default: -> { Rails.configuration.x.auth.signing_algorithm }

  hash :payload, strip: false, default: {}
  string :type

  validates! :type, inclusion: %w(ACCESS_TOKEN REFRESH_TOKEN), allow_blank: false

  def execute
    @issued_at = Time.zone.now
    @expires_at = @issued_at + ttl_in_seconds

    JWT.encode(generated_payload, secret_key, signing_algorithm)
  end

  private
    def generated_payload
      @generated_payload ||= begin
        user_uid = user.uid

        generated_payload = payload.reverse_merge(
          key: SecureRandom.base58(16),
          type: type,
          user_id: user_uid,
          iat: @issued_at.to_i,
          exp: @expires_at.to_i
        )

        transform = ActiveModelSerializers.config.key_transform
        ::CaseTransform.send(transform, generated_payload)
      end
    end

    def ttl_in_seconds
      case type
      when "ACCESS_TOKEN"
        Rails.configuration.x.auth.access_token_ttl_in_seconds
      else
        Rails.configuration.x.auth.refresh_token_ttl_in_seconds
      end
    end
end
