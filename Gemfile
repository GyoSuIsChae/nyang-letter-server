# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.4"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# An interface which glues ruby-debug to IDEs like Eclipse (RDT), NetBeans and RubyMine.
gem "ruby-debug-ide", "~> 0.7.3"

# debase is a fast implementation of the standard Ruby debugger debug.rb for Ruby 2.0+.
# It is implemented by utilizing a new Ruby TracePoint class.
# The core component provides support that front-ends can build on.
# It provides breakpoint handling, bindings for stack frames among other things.
gem "debase", "~> 0.2.5.beta2"

# Use Sass to process CSS
# gem "sassc-rails"

# Middleware that will make Rack-based apps CORS compatible. Fork the project here: https://github.com/cyu/rack-cors
gem "rack-cors", "~> 1.1", ">= 1.1.1"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # Shoulda Matchers provides RSpec- and Minitest-compatible one-liners to test common Rails functionality that, if written by hand, would be much longer, more complex, and error-prone.
  gem "shoulda-matchers", "~> 5.2"

  gem "rspec-rails", "~> 5.1", ">= 5.1.2"

  # RuboCop is a Ruby code style checking and code formatting tool.
  # It aims to enforce the community-driven Ruby Style Guide.
  gem "rubocop", "~> 1.36", require: false

  # Automatic Rails code style checking tool.
  # A RuboCop extension focused on enforcing Rails best practices and coding conventions.
  gem "rubocop-rails", "~> 2.16", ">= 2.16.1"

  # Code style checking for RSpec files.
  # A plugin for the RuboCop code style enforcing & linting tool.
  gem "rubocop-rspec", "~> 2.13", ">= 2.13.1"

  # A collection of RuboCop cops to check for performance optimizations in Ruby code.
  gem "rubocop-performance", "~> 1.15"

  # A RuboCop plugin for Rake
  gem "rubocop-rake", "~> 0.6.0"

  # Automatic Minitest code style checking tool.
  # A RuboCop extension focused on enforcing Minitest best practices and coding conventions.
  gem "rubocop-minitest", "~> 0.22.1"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# Autoload dotenv in Rails.
gem "dotenv-rails", "~> 2.8", ">= 2.8.1"

# ActiveModel::Serializers allows you to generate your JSON in an object-oriented and convention-driven manner.
gem "active_model_serializers", "~> 0.10.13"

# Extraction of the key_transform abilities of ActiveModelSerializers
gem "case_transform", "~> 0.2"

# Kaminari is a Scope & Engine based, clean, powerful, agnostic, customizable and sophisticated paginator for Rails 4+
gem "kaminari", "~> 1.2", ">= 1.2.2"

# Check the home page for more in-depth information.
gem "acts_as_paranoid", "~> 0.8.1"

# A set of common locale data and translations to internationalize and/or localize your Rails applications.
gem "rails-i18n", "~> 7.0", ">= 7.0.5"

# Object oriented authorization for Rails applications
gem "pundit", "~> 2.2"

# ActiveInteraction manages application-specific business logic.
# It is an implementation of what are called service objects, interactors, or the command pattern.
# No matter what you call it, its built to work seamlessly with Rails.
gem "active_interaction", "~> 5.1", ">= 5.1.1"

# Simple, efficient background processing for Ruby.
gem "sidekiq", "~> 6.5", ">= 6.5.7"

# Enables to set jobs to be run in specified time (using CRON notation or natural language)
gem "sidekiq-cron", "~> 1.7"

# HTTP/REST API client library.
gem "faraday", "~> 2.5", ">= 2.5.2"

# A pure ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard.
gem "jwt", "~> 2.5"
