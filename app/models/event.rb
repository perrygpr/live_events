class Event < ActiveRecord::Base
  include GuidPrimaryKey
  belongs_to :app, class_name: "App", foreign_key: "app_id"
  
  serialize :milestones
  serialize :rewards

  validates :name,               :presence => {:message => 'is missing'}
  validates :app_id,             :presence => {:message => 'is missing'}
  validates :milestones,         :presence => {:message => 'is missing'}
  validates :rewards,            :presence => {:message => 'is missing'}
  validates :eligiblesession,    :presence => {:message => 'is missing'}
  validates :eligiblelevel,      :presence => {:message => 'is missing'}
  validates :reappear,           :presence => {:message => 'is missing'}
  validates :durationactive,     :presence => {:message => 'is missing'}

  PLATFORMS = {
    'ios'     => 'iOS',
    'google'  => 'Google Play',
    'amazon'  => 'Amazon'
  }

  STATUS = {
    'current' => 'Current',
    'scheduled' => 'Scheduled',
    'running' => 'Running',
    'in_review' => 'In Review',
    'completed' => 'Completed'
  }

  RESTRICTIONS = {
    '' => 'None',
    'adhoc' => 'Ad-hoc builds only',
    'existing-participants' => 'Existing participants only',
    'all' => 'Disabled'
  }

  scope :current, lambda { where("ends_at is NULL or ends_at > ? or audited = FALSE", Time.now.utc) }
  scope :scheduled, lambda { where("starts_at is NOT NULL and starts_at > ?", Time.now.utc) }
  scope :started, lambda { where("starts_at is NULL or starts_at < ?", Time.now.utc) }
  scope :ended, lambda { where("ends_at is NOT NULL and ends_at < ?", Time.now.utc) }
  scope :not_ended, lambda { where("ends_at is NULL or ends_at > ?", Time.now.utc) }
  scope :audited, lambda { where("audited = TRUE") }
  scope :not_audited, lambda { where("audited = FALSE") }

  scope :enabled, lambda { started.not_ended }
  scope :enabled_boolean, lambda { |bypass| started.not_ended unless bypass == 'true' }
  scope :completed, lambda { ended.audited }

  scope :on_platform, lambda { |p| where("platform_#{p} = TRUE") if PLATFORMS.has_key? p }
  scope :for_country, lambda { |c| where("countries = ? or countries like ?", "#{['--'].to_yaml}", "%#{[c].to_yaml}%") }

  serialize :countries, Array

  image_accessor :notification_content do
    storage_path { |a| "#{App.find(self.app_id).name.delete(' ')}/#{self.id}/#{a.name.gsub(' ', '_')}" }
  end

  def started?
    starts_at.nil? || starts_at <= Time.now.utc
  end

  def ended?
    ends_at.present? && ends_at <= Time.now.utc
  end

  def enabled?
    started? && !ended?
  end

  def complete?
    ended? && audited?
  end

  def on_platform(platform)
    if platform == 'ios'
      platform_ios
    elsif platform == 'google'
      platform_google
    elsif platform == 'amazon'
      platform_amazon
    else
      False
    end
  end

  def platforms
    platforms = ""
    if platform_ios?
      platforms += "/" if platforms.present?
      platforms += "iOS"
    end
    if platform_google?
      platforms += "/" if platforms.present?
      platforms += "GP"
    end
    if platform_amazon?
      platforms += "/" if platforms.present?
      platforms += "AZ"
    end
    platforms
  end

  def has_notification?
    self.notification_content_uid.present?
  end

  def notification_url
    has_notification? ? "http://#{ENV['cdn_url']}/#{self.notification_content_uid}" : ""
  end

end
