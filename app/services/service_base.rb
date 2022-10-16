# frozen_string_literal: true

class ServiceBase < ActiveInteraction::Base
  class << self
    def transactionable
      include Transactionable
    end

    def paginatable
      include Paginatable
    end

    def asyncable
      include Sidekiq::Worker
      sidekiq_options retry: false
    end
  end

  def error_message
    if invalid?
      "잘못된 파라미터: " + errors.messages.keys.to_s
    end
  end

  def log_error(logger = Rails.logger)
    if invalid?
      logger.error("잘못된 파라미터: " + errors.full_messages.to_sentence)
    end
  end

  # inputs 중 주어진 것만 filter 합니다.
  # foo 가 주어지면 foo? 가 true 임을 이용합니다.
  # ```
  # class SomeClass < ServiceBase
  #    string :foo, :bar
  # end
  # k = SomeClass.new(foo: 'foo')
  #
  # k.inputs => :foo =>  'foo', :bar => nil
  # k.given_inputs => :foo => 'foo'
  # ```
  def given_inputs
    inputs.select { |k, v| send("#{k}?") }
  end
end
