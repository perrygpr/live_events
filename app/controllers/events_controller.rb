class EventsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_event, :only => [:show, :edit, :update, :destroy]

  SORT_ORDER = {
    'name_asc' => 'Name (a-z)',
    'name_desc' => 'Name (z-a)',
    'starts_asc' => 'Start (oldest)',
    'starts_desc' => 'Start (newest)',
    'ends_asc' => 'End (oldest)',
    'ends_desc' => 'End (newest)'
  }

  SORT_ORDER_SQL = {
    'name_asc' => 'name ASC',
    'name_desc' => 'name DESC',
    'starts_asc' => 'starts_at ASC',
    'starts_desc' => 'starts_at DESC',
    'ends_asc' => 'ends_at ASC',
    'ends_desc' => 'ends_at DESC'
  }

  PAGINATION_OPTIONS = {
    '15' => '15',
    '20' => '20',
    '50' => '50',
    '0' => 'All'
  }

  def index
    params[:page] = '1' if params[:search].present? || params[:per_page].present?
    merge_cookie_params
    @show_past = params[:show_past].present? && params[:show_past] == 'true'

    filters = ""
    if params[:app_id].present?
      filters += ") AND (" if !filters.empty?
      filters += "`events`.`app_id` = '#{params[:app_id]}'"
      @app = App.find_by_id(params[:app_id])
    end
    if params[:platform].present?
      filters += ") AND (" if !filters.empty?
      if params[:platform] == 'ios'
        filters += "`events`.`platform_ios` = 1"
      elsif params[:platform] == 'google'
        filters += "`events`.`platform_google` = 1"
      elsif params[:platform] == 'amazon'
        filters += "`events`.`platform_amazon` = 1"
      end
    end
    if params[:search].present?
      filters += ") AND (" if !filters.empty?
      filters += "`events`.`name` LIKE '%#{params[:search]}%'"
    end

    # Apply defaults
    params[:sort_by] = 'name_asc' if !params[:sort_by].present?
    params[:per_page] = '15' if !params[:per_page].present?
    params[:page] = '1' if !params[:page].present?

    if params[:per_page] != '0'
      @events = Event.where(filters).paginate(:page => params[:page], :per_page => params[:per_page]).reorder(SORT_ORDER_SQL[params[:sort_by]])
    else
      @events = Event.where(filters).reorder(SORT_ORDER_SQL[params[:sort_by]])
    end
    @events = @events.enabled unless @show_past

    save_cookie_params
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new
    if @event.update_attributes(build_joins.merge(event_params))
      flash[:notice] = "Successfully created event"
      redirect_to events_path
    else
      flash.now[:error] = "Error creating event"
      render :action => :new
    end
  end

  def show
    respond_to do |f|
      f.html
      f.csv do
        response.headers['Content-Disposition'] = "attachment; filename=\"PFLE Event Data- #{@event.name}.csv\""
      end
    end
  end

  def edit
  end

  def update
    if @event.update_attributes(build_joins.merge(event_params))
      flash[:notice] = "Successfully updated event"
      redirect_to events_path
    else
      flash.now[:error] = "Error updating event"
      render :action => :edit
    end
  end

  def destroy
    begin
      @event.destroy
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Cannot delete events with associated events"
    end

    redirect_to events_path
  end

  private

    def merge_cookie_params
      params[:app_id] = cookies[:event_app_id] if params[:app_id].nil? && cookies[:event_app_id].present?
      params[:platform] = cookies[:event_platform] if params[:platform].nil? && cookies[:event_platform].present?
      params[:search] = cookies[:event_search] if params[:search].nil? && cookies[:event_search].present?
      params[:sort_by] = cookies[:event_sort_by] if params[:sort_by].nil? && cookies[:event_sort_by].present?
      params[:page] = cookies[:event_page] if params[:page].nil? && cookies[:event_page].present?
      params[:per_page] = cookies[:event_per_page] if params[:per_page].nil? && cookies[:event_per_page].present?
    end

    def save_cookie_params
      cookies[:event_app_id] = params[:app_id] if !params[:app_id].nil?
      cookies[:event_platform] = params[:platform] if !params[:platform].nil?
      cookies[:event_search] = params[:search] if !params[:search].nil?
      cookies[:event_sort_by] = params[:sort_by] if !params[:sort_by].nil?
      cookies[:event_page] = params[:page] if !params[:page].nil?
      cookies[:event_per_page] = params[:per_page] if !params[:per_page].nil?
    end

    def build_joins
      additional_fields = Hash.new
      if params[:platform_ios].present? && params[:platform_ios] == '1'
        additional_fields[:platform_ios] = 1
      else
        additional_fields[:platform_ios] = 0
      end
      if params[:platform_google].present? && params[:platform_google] == '1'
        additional_fields[:platform_google] = 1
      else
        additional_fields[:platform_google] = 0
      end
      if params[:platform_amazon].present? && params[:platform_amazon] == '1'
        additional_fields[:platform_amazon] = 1
      else
        additional_fields[:platform_amazon] = 0
      end
      additional_fields
    end

    def event_params
      params.require(:event).permit(:name, :milestones, :rewards, :eligiblesession, :eligiblelevel, :reappear, :durationactive, :app_id, :platform_ios, :platform_google, :platform_amazon, :starts_at, :ends_at, :min_app_version, :min_asset_tag, :notification_content, :performance_throttle, :restrictions)
    end

    def find_event
      @event = Event.find(params[:id])
    end

end
