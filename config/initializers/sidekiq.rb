# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_SIDEKIQ_DSN", "") }

  schedule_file = "config/_schedule.yml"
  Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file) if File.exist?(schedule_file)
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_SIDEKIQ_DSN", "") }
end

Sidekiq.logger = Logger.new(STDOUT)

if ENV["SIDEKIQ_TESTING"] || Rails.env.test?
  require "sidekiq/testing"
  Sidekiq::Testing.inline!
end
