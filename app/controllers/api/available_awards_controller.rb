class API::AvailableAwardsController < API::BaseController
  before_filter :find_device, :validate_token

  self.required_params = [:app_id, :player_id]

  # This controller returns a list of all un-redeemed entries from the
  # awards table, available to a specific player.

  def index
    AnalyticsEvent.create(remote_ip: request.remote_ip,
                 device: @device,
                 type: :available_awards,
                 timestamp: Time.now,
                 app_id: params[:app_id],
                 device_token_id: params[:security_token],
                 player_id: params[:player_id])

    awards = Array.new
    all_awards = Award.where({:app_id => params[:app_id], :player_id => params[:player_id], :device_id => nil})
    all_awards.each do |a|
      awards.push(a.id)
    end
    render :json => {"status" => "OK", "awards" => awards}
  end

end
