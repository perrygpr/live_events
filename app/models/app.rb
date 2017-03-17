class App < ActiveRecord::Base
  include GuidPrimaryKey

  validates :name, :presence => {:message => 'is missing'}
end
