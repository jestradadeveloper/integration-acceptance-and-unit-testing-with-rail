class WelcomeController < ApplicationController
  def index
    request.variant = :without_turbo_stream if request.headers['Turbo-Frame'].nil?
  end
end
