class DeviceToken < ActiveRecord::Base
  include GuidPrimaryKey

  before_validation :ensure_token

  belongs_to :device
  belongs_to :install_record

  validates :device, :presence => true
  validates :install_record, :presence => true
  validates :token, :presence => true
  validate :install_record_associated_with_device
  validate :token_cannot_change, :on => :update


  def ensure_token
    if token.blank?
      self.token = generate_token
    end
  end

  private

  def generate_token
    loop do
      token = Devise.friendly_token
      break token unless DeviceToken.where(token: token).first
    end
  end

  def token_cannot_change
    errors.add(:token, "cannot change") if token_was != token
  end

  def install_record_associated_with_device
    errors.add(:install_record, "not associated with device") unless self.device.install_records.find(self.install_record.id)
  end

end
