# frozen_string_literal: true

module ParameterAcceptable
  extend ActiveSupport::Concern

  included do
    def self.parameter_to_send
      @@parameter_to_send
    end

    def self.define_params(parameter_to_send, definition)
      @@parameter_to_send = parameter_to_send
      @@defined_params = definition
    end

    def self.defined_params
      @@defined_params
    end

    def self.ref_params
      definition = yield
      Proc.new { param_filters(definition) }
    end
  end

  attr_accessor :permitted_params

  def accept_params(*filter_names)
    params = send(self.class.parameter_to_send)
    @permitted_params = params.permit(param_filters(filter_names))
    @permitted_params
  end

  def param_filters(filter_names)
    filter_names.collect do |filter_name|
      defined_params = self.class.defined_params

      filter = defined_params.fetch(filter_name, [filter_name])
      filter = instance_eval(&filter) if filter.respond_to?(:call)

      filter
    end
  end
end
