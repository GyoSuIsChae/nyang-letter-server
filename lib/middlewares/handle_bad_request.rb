
# lib/middlewares/handle_bad_request.rb
# frozen_string_literal: true

module Middleware
  class HandleBadRequest
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue ActionDispatch::Http::Parameters::ParseError => error
      error_output = "There was a problem in the JSON you submitted: #{error}"
      require "faraday"
      req = Rack::Request.new(env)
      Faraday.post(req.base_url + "/400", { error: error.to_s, request_was: req.body.string })

      [
        302, { "Location" => "/400" }, ["Bad Request: #{error_output}"]
      ]
    end
  end
end
