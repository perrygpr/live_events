class API::RequestTokenController < API::BaseController
  before_filter :find_device

  # This token assigns secret token to device
  def index
    install_record = @device.install_records.where(install_id: params[:install_id]).first
    existing_token = DeviceToken.where(device_id: @device.id,
                                       install_record_id: install_record.id).first

    if existing_token and existing_token.used
      render :json => {:status => "error", :message => "Device already has token"}, :status => 400
    else
      DeviceToken.where(device_id: @device.id,
                        install_record_id: install_record.id).delete_all if existing_token
      AnalyticsEvent.create(remote_ip: request.remote_ip,
                   device: @device,
                   type: :request_token,
                   timestamp: Time.now,
                   app_id: params[:app_id])


      token = DeviceToken.create(device_id: @device.id,
                                 install_record_id: install_record.id)

      render :json => { :status => "success",
                        :token => token.token}

    end
  end

end
