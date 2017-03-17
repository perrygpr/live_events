class HealthCheckController < ApplicationController
  def check
    head :ok
  end
end
