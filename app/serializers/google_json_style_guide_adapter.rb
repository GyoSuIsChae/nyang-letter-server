# frozen_string_literal: true

class GoogleJsonStyleGuideAdapter < ActiveModelSerializers::Adapter::Base
  def serializable_hash(options = { type: :api })
    options = serialization_options(options)
    options[:fields] ||= instance_options[:fields]
    @serialized = serializer.serializable_hash(instance_options, options, self)

    api_version = options.fetch(:api_version, ActiveModelSerializers.config.default_api_version)
    params = options.fetch(:params, {})

    @document = {
      api_version: api_version,
      params: params
    }

    if options[:type] == :error
      @error = @serialized
      build_error
    else
      build_data
    end

    self.class.transform_key_casing!(@document, instance_options)
  end

  protected
    def build_error
      # message 를 지정하지 않은 경우 코드번호를 HTTP Status 메시지로 변환해 채움
      # code: 필수값
      raise "in Error hash, :status is mandatory." unless @error[:status]
      @error[:status] = Rack::Utils.status_code(@error[:status])
      @error[:code] = @error[:code]
      @error[:message] ||= Rack::Utils::HTTP_STATUS_CODES[@error[:status]]
      @error[:debug_context] = @error[:context]
      @document[:error] = @error.slice(:status, :code, :message, :context)
    end

    def build_data
      if @serialized.is_a? Array
        @document[:data] = datum
      else
        @document[:data] = @serialized
      end
    end

    def datum
      # object 가 kaminari 의 구현체인지 확인
      # 구현체인경우 페이징 메타데이터는 serializer.object 에서 사용가능
      total_count = if serializer.object.respond_to?(:total_count)
        serializer.object.total_count
      else
        @serialized.size
      end

      @document[:data] = {
        total_items: total_count,
        size: @serialized.size,
        items: @serialized
      }
    end
end
