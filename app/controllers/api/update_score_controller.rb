class API::UpdateScoreController < API::BaseController
  before_filter :find_device, :find_event, :validate_token

  # TBD: remove player_id and retrieve that based on the auth token
  self.required_params = [:app_id, :event_id, :player_id, :name, :value, :milestones_attained]

  def index
    AnalyticsEvent.create(remote_ip: request.remote_ip,
                 device: @device,
                 type: :update_score,
                 timestamp: Time.now,
                 app_id: params[:app_id],
                 event_id: params[:event_id],
                 device_token_id: params[:security_token],
                 player_id: params[:player_id],
                 score_name: params[:name],
                 score_value: params[:value])

    # Update or insert using (app_id, event_id, player_id)
    # game reports milestones_attained, info is part of Event Progress dialog
    score = Score.where({:event_id => params[:event_id], :player_id => params[:player_id], :name => params[:name]}).first
    if score.nil?
      # TBD: set the is_cheater boolean, if necessary
      score = Score.create(event_id: params[:event_id],
                           player_id: params[:player_id],
                           name: params[:name],
                           value: params[:value].to_i,
                           milestones_attained: params[:milestones_attained],
                           timestamp: Time.now)
    else
      score.value = params[:value].to_i
      score.milestones_attained = params[:milestones_attained]
      score.timestamp = Time.now
      score.save
    end

    # TBD - Any type or error checking needed?
    render :json => {"status" =>  "OK"}
  end

end
