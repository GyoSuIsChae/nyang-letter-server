# frozen_string_literal: true

class WelcomeController < ApplicationController
  def ping
    render api: { ping: "pong", hostname: Socket.gethostname }
  end
end
