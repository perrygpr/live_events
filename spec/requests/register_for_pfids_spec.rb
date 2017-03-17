require 'rails_helper'

RSpec.describe "RegisterForPfids", :type => :request do
  describe "GET /register_for_pfids" do
    it "works! (now write some real specs)" do
      get register_for_pfids_path
      expect(response.status).to be(200)
    end
  end
end
