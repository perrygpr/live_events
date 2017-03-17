class AppsController < ApplicationController
  before_action :authenticate_user!
  before_filter :find_app, :only => [:show, :edit, :update, :destroy]

  SORT_ORDER = {
    'name_asc' => 'Name (a-z)',
    'name_desc' => 'Name (z-a)'
  }

  SORT_ORDER_SQL = {
    'name_asc' => 'name ASC',
    'name_desc' => 'name DESC'
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

    filters = ""
    if params[:search].present?
      filters += ") AND (" if !filters.empty?
      filters += "`apps`.`name` LIKE '%#{params[:search]}%'"
    end

    # Apply defaults
    params[:sort_by] = 'name_asc' if !params[:sort_by].present?
    params[:per_page] = '15' if !params[:per_page].present?
    params[:page] = '1' if !params[:page].present?

    if params[:per_page] != '0'
      @apps = App.where(filters).paginate(:page => params[:page], :per_page => params[:per_page]).reorder(SORT_ORDER_SQL[params[:sort_by]])
    else
      @apps = App.where(filters).reorder(SORT_ORDER_SQL[params[:sort_by]])
    end

    save_cookie_params
  end

  def new
    @app = App.new
  end

  def create
    @app = App.new()
    if @app.update_attributes(app_params)
      flash[:notice] = "Successfully created app"
      redirect_to apps_path
    else
      flash.now[:error] = "Error creating app"
      render :action => :new
    end
  end

  def show
    respond_to do |f|
      f.html
      f.csv do
        response.headers['Content-Disposition'] = "attachment; filename=\"PFLE App Data- #{@app.name}.csv\""
      end
    end
  end

  def edit
  end

  def update
    if @app.update_attributes(app_params)
      flash[:notice] = "Successfully updated app"
      redirect_to apps_path
    else
      flash.now[:error] = "Error updating app"
      render :action => :edit
    end
  end

  def destroy
    begin
      @app.destroy
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Cannot delete apps with associated events"
    end

    redirect_to apps_path
  end

  private

    def merge_cookie_params
      params[:search] = cookies[:app_search] if params[:search].nil? && cookies[:app_search].present?
      params[:sort_by] = cookies[:app_sort_by] if params[:sort_by].nil? && cookies[:app_sort_by].present?
      params[:page] = cookies[:app_page] if params[:page].nil? && cookies[:app_page].present?
      params[:per_page] = cookies[:app_per_page] if params[:per_page].nil? && cookies[:app_per_page].present?
    end

    def save_cookie_params
      cookies[:app_search] = params[:search] if !params[:search].nil?
      cookies[:app_sort_by] = params[:sort_by] if !params[:sort_by].nil?
      cookies[:app_page] = params[:page] if !params[:page].nil?
      cookies[:app_per_page] = params[:per_page] if !params[:per_page].nil?
    end

    def app_params
      params[:app][:secret_key] = SecureRandom.hex(16) if @app.secret_key.blank?
      params.require(:app).permit(:name, :secret_key)
    end

    def find_app
      @app = App.find(params[:id])
    end

end
