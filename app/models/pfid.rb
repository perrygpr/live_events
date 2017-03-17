class Pfid < ActiveRecord::Base
  include GuidPrimaryKey

  before_create :set_username
  
  validate :check_has_id, :message => "No GUID player id recorded"
  
  protected
  
  def set_username
  end
  
  private
  
  def check_has_id
    if last_guid.blank?
      return false
    else
      return true
    end
  end

  def check_has_username
  end

end
