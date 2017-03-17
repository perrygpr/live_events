class Device < ActiveRecord::Base
  include GuidPrimaryKey

  validate :check_has_id, :message => "No device id provided"

  has_many :install_records
  has_many :device_tokens

  private

  def check_has_id
    if advertising_id.blank? and android_id.blank? and vendor_id.blank?
      return false
    else
      return true
    end
  end

end
