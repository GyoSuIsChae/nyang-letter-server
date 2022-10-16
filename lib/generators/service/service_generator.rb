# frozen_string_literal: true

class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)
  desc "This generator creates an initializer file at app/services/"

  def create_interaction_file
    template "service.rb.erb", "app/services/#{file_path}_service.rb"
  end

  def create_interaction_test_file
    template "service_spec.rb.erb", "spec/services/#{file_path}_service_spec.rb"
  end
end
