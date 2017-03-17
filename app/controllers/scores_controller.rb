class ScoresController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_score, :only => [:show, :edit, :update, :destroy]

  SORT_ORDER = {
    'player_asc' => 'Player (a-z)',
    'player_desc' => 'Player (z-a)',
    'value_asc' => 'Value (lowest)',
    'value_desc' => 'Value (highest)',
    'update_asc' => 'Update (oldest)',
    'update_desc' => 'Update (newest)'
  }

  SORT_ORDER_SQL = {
    'player_asc' => 'player_id ASC',
    'player_desc' => 'player_id DESC',
    'value_asc' => 'value ASC',
    'value_desc' => 'value DESC',
    'update_asc' => 'updated_at ASC',
    'update_desc' => 'updated_at DESC',
  }

  PAGINATION_OPTIONS = {
    '15' => '15',
    '20' => '20',
    '50' => '50',
    '0' => 'All'
  }

  def index
    params[:page] = '1' if params[:search].present? || params[:per_page].present?
    params[:event_id] = '' if params[:app_id].present?
    params[:name] = '' if params[:app_id].present? || params[:event_id].present?
    merge_cookie_params

    filters = ""
    if params[:event_id].present?
      filters += ") AND (" if !filters.empty?
      filters += "`scores`.`event_id` = '#{params[:event_id]}'"
      @event = Event.find_by_id(params[:event_id])
    end
    if params[:name].present?
      filters += ") AND (" if !filters.empty?
      filters += "`scores`.`name` = '#{params[:name]}'"
    end
    if params[:player].present?
      filters += ") AND (" if !filters.empty?
      filters += "`events`.`player_id` LIKE '%#{params[:player]}%'"
    end

    # Apply defaults
    params[:sort_by] = 'value_desc' if !params[:sort_by].present?
    params[:per_page] = '15' if !params[:per_page].present?
    params[:page] = '1' if !params[:page].present?

    if params[:app_id].present?
      @events = Event.where("`events`.`app_id` = '#{params[:app_id]}'")
      if params[:event_id].present?
        @score_names = Score.where("`scores`.`event_id` = '#{params[:event_id]}'").uniq.pluck(:name)
        if params[:name].present?
          if params[:per_page] != '0'
            @scores = Score.where(filters).paginate(:page => params[:page], :per_page => params[:per_page]).reorder(SORT_ORDER_SQL[params[:sort_by]]).join_cheaters
          else
            @scores = Score.where(filters).reorder(SORT_ORDER_SQL[params[:sort_by]]).join_cheaters
          end
        end
      end
      @app = App.find_by_id(params[:app_id])
    end

    save_cookie_params
  end

  def edit
  end

  def update
    if (defined? params[:score][:cheater_notes]) && params[:score][:cheater_notes] != @score.cheater_notes
      logger.info params[:score][:cheater_notes]
      logger.info @score.cheater_notes
      cheater = Cheater.where({:player_id => @score.player_id}).first
      if params[:score][:cheater_notes].present?
        if cheater.nil?
          flash[:error] = "Banned player as a cheater"
          cheater = Cheater.create(player_id: @score.player_id, notes: params[:score][:cheater_notes])
        else
          flash[:error] = "Updated cheater description"
          cheater.notes = params[:score][:cheater_notes]
          cheater.save
        end
      else
        flash[:error] = "Un-banned player"
        if !cheater.nil?
          cheater.delete
        end
      end
    end
    if params[:score][:value].to_i != @score.value
      if @score.update_attributes(score_params)
        flash[:notice] = "Successfully updated score"
      else
        flash.now[:error] = "Error updating score"
        render :action => :edit
        return
      end
    end
    redirect_to scores_path
  end

  private

    def merge_cookie_params
      params[:app_id] = cookies[:score_app_id] if params[:app_id].nil? && cookies[:score_app_id].present?
      params[:event_id] = cookies[:score_event_id] if params[:event_id].nil? && cookies[:score_event_id].present?
      params[:name] = cookies[:score_name] if params[:name].nil? && cookies[:score_name].present?
      params[:player_id] = cookies[:score_player_id] if params[:player_id].nil? && cookies[:score_player_id].present?
      params[:sort_by] = cookies[:score_sort_by] if params[:sort_by].nil? && cookies[:score_sort_by].present?
      params[:page] = cookies[:score_page] if params[:page].nil? && cookies[:score_page].present?
      params[:per_page] = cookies[:score_per_page] if params[:per_page].nil? && cookies[:score_per_page].present?
    end

    def save_cookie_params
      cookies[:score_app_id] = params[:app_id] if !params[:app_id].nil?
      cookies[:score_event_id] = params[:event_id] if !params[:event_id].nil?
      cookies[:score_name] = params[:name] if !params[:name].nil?
      cookies[:score_player_id] = params[:player_id] if !params[:player_id].nil?
      cookies[:score_sort_by] = params[:sort_by] if !params[:sort_by].nil?
      cookies[:score_page] = params[:page] if !params[:page].nil?
      cookies[:score_per_page] = params[:per_page] if !params[:per_page].nil?
    end

    def score_params
      params.require(:score).permit(:value)
    end

    def find_score
      @score = Score.where(:id => params[:id]).join_cheaters.first
    end

end
