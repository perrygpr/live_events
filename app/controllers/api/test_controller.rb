class Api::TestController < ApplicationController

  def index
    logger.info "test"

    render :json => {"status" =>  "OK"}
  end

end
