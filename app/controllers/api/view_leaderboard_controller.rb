class API::ViewLeaderboardController < API::BaseController
  before_filter :find_device, :find_event

  # TBD: remove player_id and get that from auth token
  self.required_params = [:app_id, :event_id, :name, :player_id, :position, :per_page]

  def index
    AnalyticsEvent.create(remote_ip: request.remote_ip,
                 device: @device,
                 type: :view_leaderboard,
                 timestamp: Time.now,
                 app_id: params[:app_id],
                 event_id: params[:event_id],
                 player_id: params[:player_id],
                 score_name: params[:name])

    # return JSON containing list of positions
    # position = 0 indicates the player's own position

    position = params[:position].to_i
    per_page = params[:per_page].to_i

    scores = Score.where({:event_id => params[:event_id], :name => params[:name]})

    if position <= 0
      # Determine rank of current player
      score = scores.where({:player_id => params[:player_id]}).first
      if score.present?
        value = score.value
        position = scores.where("value > #{value}").count
        logger.info "player is ranked #{position+1}"
        # Set position so player appears in the middle of the page
        offset = position - (per_page / 2)
      else
        offset = 0
      end
    else
      offset = position - 1
    end
    offset = 0 if offset < 0

    # TBD: only do this join if the player is NOT a cheater
    scores = scores.no_cheaters
    #scores = scores.where(:is_cheater => [false, nil])

    # Get page of leaderboard entries; for each, return JSON:
    #    position
    #    player (display name, not player_id)
    #    score.value
    leaderboard = Array.new
    scores.order("value DESC").limit(per_page).offset(offset).each do |score|
      offset += 1
      # TBD - replace with display name
      leaderboard.push({ :position => offset, :player_id => score.player_id, :value => score.value })
    end

    render :json => {"status" =>  "OK", "leaderboard" => params[:name], "scores" => leaderboard}
  end

end
