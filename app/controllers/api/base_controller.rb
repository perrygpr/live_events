class API::BaseController < ActionController::Base
  self.class_attribute :required_params, :global_required_params

  before_filter :check_required_params, :set_geoip_params

  self.global_required_params = [
    :app_id,
    :app_version,
    :language_code,
    :device_type,
    :os,
    :os_version,
    :install_id,
    [ :vendor_id,
      :android_id,
      :advertising_id
    ]
  ]

  # CUSTOM EXCEPTION HANDLING
  rescue_from Exception do |e|
    error(e)
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  protected

  def error(e)
    if env["ORIGINAL_FULLPATH"] =~ /^\/api/
      error_info = {
        :error => "internal-server-error",
      }
      if Rails.env.development?
        error_info[:exception] = "#{e.class.name} : #{e.message}",
        error_info[:trace] = e.backtrace[0,10]
      end
      render :json => error_info.to_json, :status => 500
    else
      raise e
    end
  end

  private

    def find_app
      @app = App.find_by_id(params[:app_id])
    end

    def find_device
      params[:install_id] = params[:install_id].gsub(/-|\W/, '')
      set_geoip_params unless params[:geo_ip_country_code]

      find_app unless @app
      if !@app.present?
        render :status => 400, :json => { :error => "Invalid request: Unknown app_id."}
        return
      end

      # Find install record from install id and app id
      install_record = InstallRecord.where(install_id: params[:install_id],
                                           app_id:     @app.id).first_or_initialize do |new_install|
        new_install.install_timestamp = Time.now()
        new_install.install_version = params[:app_version]
      end

      @device ||= Device.where("vendor_id = ? OR android_id = ? OR advertising_id = ?",
                               params[:vendor_id],
                               params[:android_id],
                               params[:advertising_id]).first_or_create
      @device.update_attributes(device_params)

      install_record.device_id = @device.id
      install_record.last_timestamp = Time.now
      install_record.last_version = params[:app_version]
      install_record.save!

      @device
    end

    def validate_token
      if params[:security_token]
        find_device unless @device
        device_token = DeviceToken.where(device_id: @device.id, token: params[:security_token]).first
        if device_token and device_token.install_record.install_id == params[:install_id]
          device_token.used = true
          device_token.save
        else
          render :status => 403, :json => { :error => "Invalid security token."}
        end
      else
        render :status => 400, :json => { :error => "No security token provided."}
      end
    end

    def find_event
      @event = Event.find_by_id(params[:event_id])
      if !@event.present?
        render :status => 400, :json => { :error => "Invalid request: Unknown event_id."}
        return
      end
      @event
    end

    def check_required_params
      meets_requirements = true
      missing_parameters = []
      (self.global_required_params + Array(self.required_params)).each do |outer_param|
        unless Array(outer_param).any? { |inner_param| params.has_key?(inner_param) and not params[inner_param].blank? }
          Rails.logger.debug "Missing parameter: #{outer_param}"
          missing_parameters << (outer_param.kind_of?(Array) ? outer_param.to_sentence(:last_word_connector => ' or ', :two_words_connector => ' or ') : outer_param)
          meets_requirements = false
        end
      end

      unless meets_requirements
        render :status => 400, :json => { :error => "Invalid request: missing required parameters.",
                                          :missing_parameters => missing_parameters }
      end
    end

    def set_geoip_params
      params.merge(:geo_ip_country_code => GeoIP.new('tmp/GeoIP.dat').country(request.remote_ip)['country_code2'])
    end

    def device_params
      params.permit(:advertising_id, :vendor_id, :android_id, :country, :language_code, :os, :os_version, :device_type)
    end

end
