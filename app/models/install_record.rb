class InstallRecord < ActiveRecord::Base
  include GuidPrimaryKey

  before_create :log_install

  belongs_to :device, class_name: "Device", foreign_key: "device_id"
  belongs_to :app, class_name: "App", foreign_key: "app_id"

  validates :device_id, :presence => true
  validates :app_id, :presence => true
  validates :install_id, :presence => true

  private

  def log_install
    AnalyticsEvent.create(device: self.device,
                          type: :install,
                          timestamp: self.install_timestamp,
                          app_id: self.app_id)
  end

end
