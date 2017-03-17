class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user
      flash.notice = "Signed in through Google!"
      sign_in_and_redirect user
    else
      flash.notice = "Invalid email, if you think this is an error contact core services"
      redirect_to root_path
    end
  end
end
