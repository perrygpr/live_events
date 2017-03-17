require "spec_helper"
require "pfid"

describe Pfid do
  it "is named Pfid" do
    pfid = Pfid.new
    pfid.name.should == 'Pfid'
  end
end
