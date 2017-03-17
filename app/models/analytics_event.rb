class AnalyticsEvent < ActiveRecord::Base
  include GuidPrimaryKey

  validates_inclusion_of :type, :in => [:available_awards,
                                        :connect,
                                        :install,
                                        :registerpfid,
                                        :request_award,
                                        :update_score,
                                        :view_leaderboard], :allow_nil => false

  belongs_to :device, class_name: "Device", foreign_key: "device_id"
  belongs_to :app, class_name: "App", foreign_key: "app_id"
  belongs_to :event, class_name: "Event", foreign_key: "event_id"
  belongs_to :device_token, class_name: "DeviceToken", foreign_key: "device_token_id"

  self.inheritance_column =  :_type_disabled
end
