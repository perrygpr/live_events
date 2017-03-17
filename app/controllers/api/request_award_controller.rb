class API::RequestAwardController < API::BaseController
  before_filter :find_device, :find_event, :validate_token

  self.required_params = [:app_id, :event_id, :player_id, :name, :milestone, :reward]

  # This controller enforces that each award is only awarded once
  # It protects against some save file and multiple device exploits
  # The client will only give awards if this endpoint returns ok

  def index
    AnalyticsEvent.create(remote_ip, request.remote_ip,
                 device: @device,
                 type: :request_award,
                 timestamp: Time.now,
                 app_id: params[:app_id],
                 event_id: params[:event_id],
                 device_token_id: params[:security_token],
                 player_id: params[:player_id],
                 award_name: params[:name])

    # attempt to insert into awards table
    # table rules will reject insertion if there is an existing row with the same player_id, event_id, name

    # works for a particular milestone and associated reward, where for small events there can be 3 - 8
    award = Award.where({:event_id => params[:event_id], :player_id => params[:player_id], :name => params[:name], 
      :milestone => params[:milestone], :reward => params[:reward]}).first
    if award.nil?
      award = Award.create(event_id: params[:event_id],
                            player_id: params[:player_id],
                            device_id: @device.id,
                            name: params[:name],
                            milestone: params[:milestone],
                            reward: params[:reward],
                            timestamp: Time.now)
      # return ok only if no entry exists
      render :json => {"status" => "OK"}
    else
      render :json => {"status" => "Already awarded"}
    end
  end

end
