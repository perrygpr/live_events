class API::ConnectController < API::BaseController
  before_filter :find_device

  def index
    AnalyticsEvent.create(remote_ip: request.remote_ip,
                 device: @device,
                 type: :connect,
                 timestamp: Time.now,
                 app_id: params[:app_id])

    events = Array.new
    Event.enabled.on_platform(@device.os).each do |e|
    if @device.country.present?
      all_events = all_events.for_country(@device.country)
    end
    all_events.each do |e|
      if !e.started?
        # TBD: allow PM to set a flag to hide future scheduled events
        status = "scheduled"
      elsif !e.ended?
        status = "running"
      else
        status = "results_pending"
      end
      events.push({:id => e.id,
                   :name => e.name,
                   :status => status,
                   :starts_at => e.starts_at.utc.to_formatted_s(:db),
                   :ends_at => e.ends_at.utc.to_formatted_s(:db),
                   :milestones => e.milestones,
                   :rewards => e.rewards,
                   :eligiblesession => e.eligiblesession,
                   :eligiblelevel => e.eligiblelevel,
                   :reappear => e.reappear,
                   :durationactive => e.durationactive,
                   :min_app_version => e.min_app_version,
                   :min_asset_tag => e.min_asset_tag,
                   :notification_url => e.notification_url,
                   :performance_throttle => e.performance_throttle,
                   :restrictions => e.restrictions || ''})
    end

    render :json => {"status" => "OK", "events" => events}
  end

end
