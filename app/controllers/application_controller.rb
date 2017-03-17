class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # Changed to do so using the prior comment which will allow POST API requests w/o a valid authenticity token to go through
  #protect_from_forgery with: :exception
  
  # Logs will show "can't verify CSRF token authenticity" this is intential to spare the API caller the burden
  protect_from_forgery with: :null_session
  
  def test_exception
      raise 'PFLE test'
  end

end
