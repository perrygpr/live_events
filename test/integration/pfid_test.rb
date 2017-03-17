require 'test/unit'
require 'test_helper'

class PfidTest < ActionDispatch::IntegrationTest
  
  test 'register for pfid' do
    post '/api/register_for_pfid'
    assert_equal 204, response.status
  end

end