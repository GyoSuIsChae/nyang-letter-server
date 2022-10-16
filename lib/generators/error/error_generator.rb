# frozen_string_literal: true

class ErrorGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)
  desc "This generator creates an initializer file at app/errors/"
  argument :code, type: :string, default: ""
  argument :message, type: :string, default: ""

  def create_interaction_file
    template "error.rb.erb", "app/errors/#{file_path}_error.rb"

    inject_into_file "config/locales/base_errors/ko.yml" do
      outcome = []
      outcome << "    #{file_path}_error:"
      outcome << "      code: #{code}"
      outcome << "      message: #{message}"
      outcome = outcome.join("\n")
      <<-YAML
#{outcome}
      YAML
    end
  end
end
